module ApplicationHelper
  def user?
    super rescue nil
  end

  def current_registration
    @current_registration = Registration.where(:id => session[:registration_id]).last || Registration.new
  end
end
