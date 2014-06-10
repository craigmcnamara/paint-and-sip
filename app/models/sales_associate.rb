# == Schema Information
#
# Table name: sales_associates
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  code       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class SalesAssociate < ActiveRecord::Base
  attr_accessible :code, :name
  has_many :living_social_codes
  validates :code, presence: true, uniqueness: true

  def to_s
    name.blank? ? code : name
  end
end
