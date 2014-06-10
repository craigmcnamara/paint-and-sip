require 'test_helper'

class RegistrationTest < ActionDispatch::IntegrationTest

  setup do
    @event = create(:event)
    get '/registrations/new', event_id: @event.id
    assert_response :success
  end

  should "register for an event" do
    charge, customer = stub(id: 1), stub(id: 2)
    Stripe::Charge.expects(:create).returns(charge)
    post '/registrations', registration: attributes_for(:registration), event_id: @event.id
    assert_redirected_to event_registration_path @event, assigns(:registration)
  end

  should "report an error when we raise an exception" do
    charge, customer = stub(id: 1), stub(id: 2)
    Stripe::Charge.stubs(:create).raises(Stripe::CardError.new("Big Problem", nil, 'card_declined'))
    post '/registrations', registration: attributes_for(:registration), event_id: @event.id
    assert_select '.alert.alert-danger'
  end

  should "should show an existing registration" do
    @registration = create(:registration)
    get registration_path(@registration)
    assert_response :success
  end
end
