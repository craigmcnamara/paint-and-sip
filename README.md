# Paint and Sip

This is an off the shelf site implementation of a paint and sip website.

It's payments are powered by strip and has basic event registration and summer camp session functions built in.

## Quickstart

On your terminal run the following commands.

`$ bundle install`
`$ bundle exec rake db:create db:setup`
`$ rails s`

Now if you visit http://localhost:3000/admin

### Configure Initializers

Edit config/initializers/stripe.rb to include your keys.

Edit config/initializers/devise.rb so you have the proper mailer_sender address configured.

Edit config/initializers/dragonfly.rb to ensure you have correct upload paths for development and production.

### Configuire config/environments/production.rb

Find this block

```ruby
  config.middleware.use ExceptionNotification::Rack, :email => {
    :email_prefix => "[Exception] ",
    :sender_address => %{"Exception Robot" <info@paint-and-sip>},
    :exception_recipients => %w{admin@paint-and-sip}
  }
```
Make sure to set up proper addresses so you get execeptions from production.

## Running Tests

`$ bundle exec rake test`

The tests will fail unless stripe is configured properly.