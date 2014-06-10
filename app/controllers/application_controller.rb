class ApplicationController < ActionController::Base
  layout ->(c){ c.params.fetch(:layout, 'pilot') }
end