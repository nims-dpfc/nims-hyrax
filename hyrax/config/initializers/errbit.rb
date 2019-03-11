Airbrake.configure do |config|
  config.host = ENV['AIRBRAKE_HOST']
  config.project_id = ENV['PROJECT_ID']
  config.project_key = ENV['PROJECT_KEY']

  config.environment = Rails.env
  config.ignore_environments = %w(development test)
end
