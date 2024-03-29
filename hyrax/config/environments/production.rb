Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Added for Rails 5.2
  config.secret_key_base = ENV['SECRET_KEY_BASE_PRODUCTION']

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  # To display stack traces in production, you want
  # config.consider_all_requests_local       = true
  # To hide stack traces in production, set this to false.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Use Sidekiq to process background jobs
  config.active_job.queue_adapter = :sidekiq

  # Attempt to read encrypted secrets from `config/secrets.yml.enc`.
  # Requires an encryption key in `ENV["RAILS_MASTER_KEY"]` or
  # `config/secrets.yml.key`.
  # config.read_encrypted_secrets = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  if ENV['RAILS_SERVE_STATIC_FILES'].present?
    config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES']
  else
    config.public_file_server.enabled = true
  end

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = Uglifier.new(harmony: true)
  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # `config.assets.precompile` and `config.assets.version` have moved to config/initializers/assets.rb

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = 'http://assets.example.com'

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX

  # Mount Action Cable outside main process or domain
  # config.action_cable.mount_path = nil
  # config.action_cable.url = 'wss://example.com/cable'
  # config.action_cable.allowed_request_origins = [ 'http://example.com', /http:\/\/example.*/ ]

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  if ENV["RAILS_FORCE_SSL"].present? && (ENV["RAILS_FORCE_SSL"].to_s.downcase == 'false') then
    config.force_ssl = false
    Rails.application.routes.default_url_options = \
      Hyrax::Engine.routes.default_url_options = \
      {protocol: 'http', host: ENV['MDR_HOST']}
    config.application_url = "http://#{ENV['MDR_HOST']}"
  else
    config.force_ssl = true #default if nothing specified is more secure.
    Rails.application.routes.default_url_options = \
      Hyrax::Engine.routes.default_url_options = \
      {protocol: 'https', host: ENV['MDR_HOST']}
    config.application_url = "https://#{ENV['MDR_HOST']}"
  end

  # Use the lowest log level (:debug) to ensure availability of diagnostic information
  # when problems arise.
  config.log_level = :info

  # Prepend all log lines with the following tags.
  config.log_tags = [ :request_id ]

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Use a different logger for distributed setups.
  # require 'syslog/logger'
  # config.logger = ActiveSupport::TaggedLogging.new(Syslog::Logger.new 'app-name')

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end


  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Use a real queuing backend for Active Job (and separate queues per environment)
  # config.active_job.queue_adapter     = :resque
  # config.active_job.queue_name_prefix = "hyrax_#{Rails.env}"
  config.action_mailer.perform_caching = false

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  # config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  config.action_mailer.perform_deliveries = true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: ENV['SMTP_HOST'],
    port: ENV['SMTP_PORT'],
    user_name: ENV['SMTP_USERNAME'],
    password: ENV['SMTP_PASS'],
    authentication: :plain,
    enable_starttls_auto: true
  }

  config.middleware.use ExceptionNotification::Rack,
    ignore_exceptions: [
      'I18n::InvalidLocale',
      'Riiif::ConversionError',
      'Blacklight::Exceptions::RecordNotFound',
      'ActionView::Template::Error',
      'Ldp::Gone',
      'URI::InvalidURIError'
    ] + ExceptionNotifier.ignored_exceptions,
    error_grouping: true,
    email: {
      email_prefix: "[MDR #{ENV['ERROR_NOTIFICATION_SUBJECT_PREFIX']}] ",
      sender_address: ENV['NOTIFICATIONS_EMAIL_DEFAULT_FROM_ADDRESS'],
      exception_recipients: [ENV['ERROR_NOTIFICATION_RECIPIENT_EMAIL']]
    }

  ExceptionNotifier::Rake.configure

  config.log_level = :info
end
