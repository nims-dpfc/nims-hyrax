require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Hyrax
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    # config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.active_job.queue_adapter = :sidekiq

    # The locale is set by a query parameter, so if it's not found render 404
    config.action_dispatch.rescue_responses.merge!(
      'I18n::InvalidLocale' => :not_found
    )
    config.i18n.default_locale = :en
    config.i18n.available_locales = [:en, :ja]
    config.i18n.fallbacks = [:en]

    config.action_dispatch.default_headers['Referrer-Policy'] = 'strict-origin-when-cross-origin'
  end
end
