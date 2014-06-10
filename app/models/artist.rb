# == Schema Information
#
# Table name: artists
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  email      :string(255)
#  phone      :string(255)
#  slug       :string(255)
#

class Artist < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  attr_accessible :name, :email, :phone
  has_many :events, :class_name => "Event"

  validates :name,
    :presence => true,
    :uniqueness => true

  validates :email,
    :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i },
    :presence => true,
    :uniqueness => true

  def to_s
    name
  end
end
