# frozen_string_literal: true
if Rails.env == 'production'
  Airbrake.configure do |config|
    # setting for the rails app
    config.environment = Rails.env
    config.ignore_environments = %w[development test]
    # ignore production if the environment variables aren't set
    config.ignore_environments << 'production' if ENV.fetch('AIRBRAKE_HOST', nil).blank? &&
                                                  ENV.fetch('AIRBRAKE_PROJECT_ID', nil).blank? &&
                                                  ENV.fetch('AIRBRAKE_PROJECT_KEY', nil).blank?
    config.host = ENV['AIRBRAKE_HOST']
    config.project_id = ENV['AIRBRAKE_PROJECT_ID']
    config.project_key = ENV['AIRBRAKE_PROJECT_KEY']
  end
elsif defined?(Airbrake)
  # disable Airbrake if the env vars are not present
  puts 'Disabling Airbrake because the required env vars are not set'
  Airbrake.configure do |c|
    c.environment = Rails.env
    c.ignore_environments = %w(development test production)
  end
end
