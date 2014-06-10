require 'dragonfly'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  protect_from_dos_attacks true
  secret "2215cd55ba53b3f0fe7053e088c5cf57a3a8a5ae90f3a83f835086f173e5379f"

  url_format "/media/:job/:name"

  datastore_root_path = begin
    if Rails.env.production?
      "/var/www/paint-and-sip/current/public/system/uploads/images"
    else
      Rails.root.join('public/system/uploads/images')
    end
  end

  datastore :file,
    root_path: datastore_root_path,
    server_root: Rails.root.join('public')
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend Dragonfly::Model
  ActiveRecord::Base.extend Dragonfly::Model::Validations
end
