if ENV.fetch('AIRBRAKE_HOST', nil).present? and
  ENV.fetch('AIRBRAKE_PROJECT_ID', nil).present? and
  ENV.fetch('AIRBRAKE_PROJECT_KEY', nil).present?
  Airbrake.configure do |config|
    config.host = ENV['AIRBRAKE_HOST']
    config.project_id = ENV['AIRBRAKE_PROJECT_ID']
    config.project_key = ENV['AIRBRAKE_PROJECT_KEY']
    # setting for the rails app
    config.environment = Rails.env
    config.ignore_environments = %w(development test)
  end
elsif defined?(Airbrake)
  # disable Airbrake if the env vars are not present
  puts 'Disabling Airbrake because the required env vars are not set'
  Airbrake.configure do |c|
    c.environment = Rails.env
    c.ignore_environments = %w(development test production)
  end
end
