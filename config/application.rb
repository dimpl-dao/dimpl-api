require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DimplServer
  class Application < Rails::Application
    config.load_defaults 7.0 
    config.time_zone = "Asia/Seoul"
    config.api_only = true
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options, :delete, :put]
      end
    end
    config.before_configuration do
      env_file = File.join(Rails.root, 'config', '.env')
      Dotenv.overload(env_file) if File.exists?(env_file)
    end
    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
    end
    config.api_only = true
    config.after_initialize do
      Thread.new {
        KlaytnSocket::Listener.call
      }
    end
  end
end
