class ArtistMailer < ActionMailer::Base
  include SendGrid
  sendgrid_category :customer_emails
  sendgrid_enable   :ganalytics, :opentrack

  CONTACT_ADDRESS = "info@example.com"

  default :reply_to => CONTACT_ADDRESS, :from => CONTACT_ADDRESS, :bcc => "info@example.com"

  def class_confirmation(event_id)
    @event = Event.find(event_id)
    mail(:to => @event.artist.email, :subject => "Upcoming gig")
  end
end
