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

require 'test_helper'

class SalesAssociateTest < ActiveSupport::TestCase
  should have_many :living_social_codes
end
