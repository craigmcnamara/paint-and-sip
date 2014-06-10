require 'test_helper'

class SummerCampsTest < ActionDispatch::IntegrationTest
  attr_reader :camp, :page

  setup do
    @page = create(:page, name: 'Summer Camps')
    @camp = create(:event, camp_session: true)
  end

  should "have a list page" do
    get summer_camps_path
    assert_response :success
  end

  should 'have a show page' do
    get new_event_registration_path camp
    assert_response :success
  end
end