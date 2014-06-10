ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/api'
require 'turn/autorun'

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
end
