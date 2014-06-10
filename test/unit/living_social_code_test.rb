# == Schema Information
#
# Table name: living_social_codes
#
#  id                 :integer          not null, primary key
#  code               :string(255)
#  type               :string(255)
#  bucket             :string(255)
#  voucher_id         :string(255)
#  registration_id    :integer
#  sales_associate_id :integer
#

require 'test_helper'

class LivingSocialCodeTest < ActiveSupport::TestCase

  should validate_presence_of :code
  should validate_presence_of :type
  should validate_presence_of :bucket

  should belong_to :sales_associate
  should belong_to :registration

  setup do
    @one = LivingSocialCode.create!(:code => "One", :type => "text", :bucket => "one")
    @two = LivingSocialCode.create!(:code => "two", :type => "text", :bucket => "two")
    @two.registration_id = 1
    @two.save!
  end

  should "have an unclaimed scope" do
    assert_equal [@one], LivingSocialCode.unclaimed
  end

  should "have a count method" do
    assert_equal 1, @one.count
    assert_equal 2, @two.count
    assert_equal 0, LivingSocialCode.new.count
  end

  context ".with_code" do
    should "be case insensitive" do
      assert_equal @one, LivingSocialCode.with_code('one').last
      assert_equal @one, LivingSocialCode.with_code('ONE').last
    end
  end
end
