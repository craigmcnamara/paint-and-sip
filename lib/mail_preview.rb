require 'ostruct'

class MailPreview < MailView
  def forgot_password
    request = Struct.new(:host_with_port, :domain).new("pain_and_sip.dev", "pain_and_sip.dev")
    user = User.last
    UserMailer.reset_notification(user, request)
  end

  def booking_confirmation
    registration = Registration.first
    CustomerMailer.booking_confirmation(registration)
  end

  def class_confirmation
    artist = Artist.last
    event = Event.last
    event.artist = artist
    event.save!
    ArtistMailer.class_confirmation event
  end
end