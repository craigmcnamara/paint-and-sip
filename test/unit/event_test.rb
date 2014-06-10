# == Schema Information
#
# Table name: events
#
#  id                 :integer          not null, primary key
#  title              :string(255)
#  from               :datetime
#  to                 :datetime
#  registration_link  :string(255)
#  description        :text
#  venue_id           :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  seats              :integer
#  seat_cost          :integer
#  image_id           :integer
#  over_21            :boolean          default(FALSE)
#  private_event      :boolean          default(FALSE)
#  artist_id          :integer
#  slug               :string(255)
#  duration           :integer          default(120)
#  allow_registration :boolean          default(TRUE)
#  camp_session       :boolean          default(FALSE)
#

require 'test_helper'

class EventTest < ActiveSupport::TestCase

  setup do
    @seat_cost = 45
    @event = Event.new seat_cost: @seat_cost
  end

  should "have a stripe_cost method that gives cost in cents" do
    assert_equal 4500, @event.stripe_cost(1)
    assert_equal 9000, @event.stripe_cost(2)
    assert_raises(ArgumentError) { @event.stripe_cost(0) }
  end

  should "assume vouchers are redeemed in full" do
    code = create(:living_social_code, :bucket => "two", :code => "code")
    assert_equal 0, @event.stripe_cost(1, code)
  end

  should "have a remaining_seats? method" do
    event = Event.new :seats => 0
    assert_equal false, event.remaining_seats?
    event = Event.new :seats => 1
    assert_equal true, event.remaining_seats?
  end

  should "have remaining_seat_options method for select tags" do
    @event.seats = 2
    assert_equal [1, 2], @event.remaining_seat_options.to_a
  end

  should "have an artist" do
    chan = create(:artist, :name => "Chan", :email => "chan@example.com")
    @event.artist = chan
    assert_equal chan, @event.artist
  end

  should "default to 3 hours long so the view doesn't explode" do
    now = Time.now
    @event.to = nil
    @event.from = now
    assert_equal (now + 3.hours).to_s, @event.to.to_s
  end

  should "have a default title if none is provided" do
    @event.stubs(:image).returns(Image.new image_name: 'test image')
    @event.save!
    assert_equal "#{Time.now.strftime('%Y-%m-%d')} - test image", @event.title
  end
end
