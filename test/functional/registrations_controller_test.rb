require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase

  test "should get new" do
    event = create(:event)
    get :new, event_id: event
    assert_response :success
  end

  context "create" do

    setup do
      @event = create(:event)
    end

    should "create registrations" do
      charge, customer = stub(id: 1), stub(id: 2)
      Stripe::Charge.expects(:create).returns(charge)

      post :create, registration: attributes_for(:registration), event_id: @event.id
      assert_redirected_to event_registration_path @event, assigns(:registration)
    end

    should "pass living_social_code to price calculator" do
      charge, customer = stub(id: 3), stub(id: 4)
      post :create, registration: attributes_for(:registration).merge(living_social_code: "666"), event_id: @event.id
      assert_response :success
    end

    should "should show a registration" do
      @registration = create(:registration)
      get :show, id: @registration
      assert_response :success
    end
  end
end
