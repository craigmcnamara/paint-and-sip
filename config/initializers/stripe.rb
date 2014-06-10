Rails.configuration.stripe = {
  :publishable_key => Rails.env.production? ? "publishable_key_production" : "publishable_key_test",
  :secret_key      => Rails.env.production? ? "secret_key_production" : "secret_key_test"
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]