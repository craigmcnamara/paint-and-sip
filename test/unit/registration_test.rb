# == Schema Information
#
# Table name: registrations
#
#  id                   :integer          not null, primary key
#  email                :string(255)
#  event_id             :integer
#  customer_id          :string(255)
#  charge_id            :string(255)
#  quantity             :integer
#  notes                :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  party_name           :string(255)
#  charged_total        :decimal(8, 2)    default(0.0)
#  phone_number         :string(255)
#  morning_camp         :boolean          default(FALSE)
#  afternoon_camp       :boolean          default(FALSE)
#  am_extended          :boolean          default(FALSE)
#  lunch_extended_hours :boolean          default(FALSE)
#  pm_extended_hours    :boolean          default(FALSE)
#

require 'test_helper'

class RegistrationTest < ActiveSupport::TestCase

  COUPON_MESSAGE = "Coupons must be redeemed in full and negative balances are not allowed."

  should validate_presence_of :email
  should allow_value("valid_email@gmail.com").for(:email)
  should allow_value("valid_email+gmail-alias@gmail.com").for(:email)
  should_not allow_value("I can't read").for(:email)

  should validate_presence_of :quantity
  should validate_numericality_of :quantity

  should validate_numericality_of(:charged_total).with_message(COUPON_MESSAGE)

  should have_one :living_social_code

  should_not allow_value("invalid_ email@gmail.com").for(:email)

  context "stripe registration" do
    setup do
      @event = create(:event)
      @charge, @customer = stub(id: 1), stub(id: 2)
    end

    should "build a valid registration" do
      Stripe::Charge.expects(:create).returns(@charge)
      params = { registration: attributes_for(:registration) }
      assert_nothing_raised do
        registration = Registration.create_stripe_registration @event, params
        assert_equal 45, (registration.charged_total / 100).to_i
      end
    end

    context "with living social codes" do
      setup do
        @code = create(:living_social_code, :code => "CMM997760")
      end

      should "apply the specified discount" do
        params = { registration: attributes_for(:registration, :quantity => 2).merge(:living_social_code => @code.code) }
        registration = Registration.create_stripe_registration @event, params
        assert_equal 2, registration.quantity
        assert_nothing_raised { registration.save! }
        assert_equal 0.0, registration.charged_total
        assert_equal @code, registration.living_social_code
        assert !LivingSocialCode.unclaimed.include?(@code)
      end

      should "be invalid when an invalid code is given" do
        assert_raises Registration::RegistrationError do
          params = { registration: attributes_for(:registration, :quantity => 2).merge(:living_social_code => "NOT_VALID") }
          registration = Registration.create_stripe_registration @event, params
        end
      end

      should "not allow negative discounts" do
        params = { registration: attributes_for(:registration, :quantity => 1).merge(:living_social_code => @code.code) }
        registration = Registration.create_stripe_registration @event, params
        assert_equal 0.0, registration.charged_total
        assert !LivingSocialCode.unclaimed.include?(@code)
      end
    end
  end

  context 'registration for a camp' do
    setup { @event = create(:event, camp_session: true) }

    should 'be able to set camp specific flags' do
      assert_nothing_raised do
        params = { registration: attributes_for(:registration, morning_camp: true, afternoon_camp: true, am_extended: true,
          lunch_extended_hours: true, pm_extended_hours: true)}
        registration = Registration.create_stripe_registration @event, params
        assert registration.morning_camp
        assert registration.afternoon_camp
        assert registration.am_extended
        assert registration.lunch_extended_hours
        assert registration.pm_extended_hours
        assert_equal 46000, registration.charged_total.to_i
        assert_equal 460, registration.charged_in_dollars
      end
    end
  end
end
