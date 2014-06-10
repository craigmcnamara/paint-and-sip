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

class Registration < ActiveRecord::Base

  class RegistrationError < RuntimeError ; end

  attr_accessible :email, :quantity, :notes, :party_name, :customer_id, :charge_id, :charged_total, :phone_number,
    :morning_camp, :afternoon_camp, :am_extended, :lunch_extended_hours, :pm_extended_hours

  validates :email, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }, :presence => true
  validates :phone_number, :presence => true
  validates :quantity, presence: true, numericality: true
  validates :charged_total, numericality: { greater_than_or_equal_to: 0, message: "Coupons must be redeemed in full and negative balances are not allowed."}, allow_nil: true

  belongs_to :event, :class_name => "Event"
  has_one :living_social_code

  scope :has_living_social_code, joins(:living_social_code)

  attr_accessible :event_id, :party_name, :notes, :quantity, :email,
                  :customer_id, :charge_id, :phone_number, :charged_total

  after_create do |registration|
    ::EmailJob.new.async.perform(:customer_mailer, :booking_confirmation, registration.id)
  end

  def self.create_stripe_registration(event, params = {})
    code = params[:registration].delete(:living_social_code)
    params[:registration][:email] ||= params[:registration][:email] || params[:stripeEmail]
    event.registrations.build(params[:registration]).tap do |registration|
      if registration.valid?
        begin
          if customer = Stripe::Customer.create(:email => params[:stripeEmail], :card => params[:stripeToken])
            registration.customer_id = customer.id
          end

          if code && !code.blank?
            if discount_code = LivingSocialCode.unclaimed.with_code(code).last
              registration.living_social_code = discount_code
            else
              raise RegistrationError, "Invalid discount code. Please check the code on the voucher you purhased."
            end
          end

          quantity = registration.quantity = params[:registration][:quantity].to_i

          cost = registration.charged_total = event.stripe_cost(registration.quantity, discount_code, registration)

          if registration.valid? && cost > 0.0
            charge = Stripe::Charge.create(
              :customer    => customer.id,
              :amount      => cost,
              :description => "#{quantity} Registrations for #{event.title} at #{event.from.strftime("%m-%e %l:%M %p")}",
              :currency    => 'usd'
            )
            registration.charge_id = charge.id
          end
          registration.save!
        rescue Stripe::CardError => e
          registration.errors[:base] << e.message
        end
      end
    end
  end

  def charged_in_dollars
    if charged_total && charged_total > 0
      charged_total / 100
    else
      0
    end
  end
end
