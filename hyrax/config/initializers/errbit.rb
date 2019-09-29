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
end
