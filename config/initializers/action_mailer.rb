ActionMailer::Base.smtp_settings = {
  :user_name => 'pain_and_sip',
  :password => 'XXXXXXXXXX',
  :domain => 'example.com',
  :address => 'smtp.sendgrid.net',
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}

ActionMailer::Base.class_eval do
  default :from => "info@example.com"
end
