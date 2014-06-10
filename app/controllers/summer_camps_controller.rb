class SummerCampsController < ApplicationController
  respond_to :html, :js

  def index
  	@page = Page.find_by_slug('summer-camps')
    @events = Event.where(camp_session: true).all
    respond_with @events
  end
end