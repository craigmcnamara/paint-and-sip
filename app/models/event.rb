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

class Event < ActiveRecord::Base
  extend FriendlyId

  CAMP_COSTS = {
    morning_camp: 200,
    afternoon_camp: 200,
    am_extended: 20,
    lunch_extended_hours: 20,
    pm_extended_hours: 20 
  }

  friendly_id :title, use: :slugged

  just_define_datetime_picker :from
  just_define_datetime_picker :to

  has_many :registrations

  belongs_to :image
  belongs_to :artist
  belongs_to :venue

  before_validation :generate_title, :if => Proc.new{|event| event.title.nil? or event.title.blank? }

  scope :starting_from_day, lambda {|day| where(from: day.beginning_of_day..day.advance(years: 1).end_of_day) }

  after_commit :notify_artist!, on: [:create, :update]

  def generate_title
    self.title = [Time.now.strftime('%Y-%m-%d'), image.to_s].join(' - ')
  end

  def url_date
    unless new_record?
      created_at.strftime('%Y-%m-%d')
    end
  end

  def notify_artist!
    if artist
      ::EmailJob.new.async.perform(:artist_mailer, :class_confirmation, id)
    end
  end

  def registration_cost(quantity = 1, registration)
    if registration && registration.event.camp_session
      CAMP_COSTS.map{ |k, v|  v if registration.send(k) }.compact.reduce(:+)
    else
      self.seat_cost || 0
    end
  end

  def total_registered
    registrations.select(:quantity).map{|r| r.quantity }.compact.inject(:+) || 0
  end

  def seat_cost
    read_attribute(:seat_cost) || 0
  end

  def remaining_seats
    if seats
      seats - total_registered
    else
      0
    end
  end

  def remaining_seats?
    remaining_seats > 0
  end

  def remaining_seat_options
    1.upto(remaining_seats)
  end

  def stripe_cost(quantity, discount = nil, registration = nil)
    quantity = registration ? registration.quantity : quantity
    raise ArgumentError, "Invalid quantity" if quantity < 1
    cost = registration_cost(quantity, registration) * (quantity - (discount ? discount.count : 0))
    ((cost > 0) ? cost : 0) * 100
  end

  def upcoming?
    from.end_of_day >= Time.zone.now rescue false
  end

  def archived?
    from < Time.zone.now.end_of_day rescue false
  end

  def to
    if self.from && self.read_attribute(:to).nil?
       self.from + 3.hours
    else
      self.read_attribute(:to)
    end
  end

  def venue_name
    venue ? venue.name : ""
  end

  def venue_address
    venue ? venue.address : ""
  end

  def camp_dates
    [from, from + 5.days]
  end

  class << self
    def upcoming
      where('events.from >= :from', from: Time.zone.now.beginning_of_day.to_s(:db))
    end

    def featured
      where(:featured => true)
    end

    def archive
      where('events.from < :from', from: Time.zone.now.end_of_day.to_s(:db))
    end
  end
end
