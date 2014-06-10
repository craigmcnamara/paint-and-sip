# == Schema Information
#
# Table name: venues
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  address    :string(255)
#  url        :string(255)
#  phone      :string(255)
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  over_21    :boolean
#

class Venue < ActiveRecord::Base
  has_many :events
end
