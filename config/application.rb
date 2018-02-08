require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module EventManagement
  class Application < Rails::Application

    config.generators do |g|
      g.test_framework(
        :rspec,
        fixtures:         false,
        view_specs:       false,
        helper_specs:     false,
        routing_specs:    false,
        controller_specs: false,
        request_specs:    false
      )
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end

    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**/*.{rb,yml}').to_s]
    config.i18n.default_locale = :de

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.autoload_paths += %W(#{config.root}/lib)

    config.time_zone = 'Berlin'

    config.active_job.queue_adapter = :sidekiq

    # Set Redis as the back-end for the cache.
    # If not in sidekiq mode
    # if ENV['REDIS_CACHE_URL'].present?
    #   uri = URI(ENV['REDIS_CACHE_URL'])
    #   uri.password = Rails.application.secrets.em_redis_password
    #   config.cache_store = :redis_store, uri.to_s
    # end
  end
end
