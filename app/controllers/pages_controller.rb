class PagesController < ApplicationController
  respond_to :html, :xml

  def index
    if @page = Page.where(slug: 'home').last
      respond_with @page
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def show
    if @page = Page.where(slug: params[:name]).last
      respond_with @page
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end
end