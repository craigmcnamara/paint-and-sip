class CustomerMailer < ActionMailer::Base
  include SendGrid
  sendgrid_category :customer_emails
  sendgrid_enable   :ganalytics, :opentrack

  CONTACT_ADDRESS = "info@example.com"

  default :reply_to => CONTACT_ADDRESS, :from => CONTACT_ADDRESS, :bcc => "info@example.com"

  def booking_confirmation(registration_id)
    @registration = Registration.find(registration_id)
    mail(:to => @registration.email, :subject => "Thanks for Booking")
  end
end
