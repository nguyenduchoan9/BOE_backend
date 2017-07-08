require_relative 'boot'
gem 'rack-cors', :require => 'rack/cors'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MobileApi
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.time_zone = 'Hanoi'
    config.active_record.default_timezone = :utc
    config.active_record.belongs_to_required_by_default = false
    config.generators do |g|
      g.test_framework :rspec
      g.view_specs = false
      g.helper_specs = false
      g.javascripts = false
      g.stylesheets = false
      g.helper = false
      g.decorator = false
    end
    config.active_job.queue_adapter = :sidekiq
    config.middleware.use Rack::Cors do
      allow do
        origins '*'
        resource '*',
          :headers => :any,
          :expose  => ['access-token', 'expiry', 'token-type', 'uid', 'client'],
          :methods => [:get, :post, :options, :delete, :put]
      end
    end
  end
end
