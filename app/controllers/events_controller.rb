class EventsController < ApplicationController
  respond_to :html, :js

  include CalendarHelper

  def index
    @events = event_scope
    respond_with @events
  end

  protected

  def event_scope
    if params[:month]
      @date = Date.parse(params[:month]) rescue Date.today
      @calendar_class = CalendarHelper::Calendar
      Event.starting_from_day(3.months.ago).order('events.from DESC')
    else
      @date = Date.today
      @calendar_class = CreateCalendar
      Event.starting_from_day(@date.beginning_of_week).order('events.from DESC')
    end
  end

  class CreateCalendar < CalendarHelper::Calendar
    def initialize(options = {})
      super(options.reverse_merge(:first => :today, :last => :thirty))
    end
  end
end