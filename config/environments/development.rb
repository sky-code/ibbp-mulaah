Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  config.action_controller.perform_caching = false
  config.cache_store = :redis_store, {
    expires_in: 5.minutes.to_i,
    redis: { url: ENV['REDIS_URL'] || 'redis://localhost:6379' }
  }

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  config.after_initialize do
    ActiveRecord::Base.logger       = Rails.logger.clone
    ActiveRecord::Base.logger.level = Logger::WARN
  end

  if [ENV['SMTP_ADDRESS'], ENV['SMTP_PORT'], ENV['SMTP_USER_NAME'], ENV['SMTP_PASSWORD']].all?(&:present?)
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address:              ENV['SMTP_ADDRESS'],
      port:                 ENV['SMTP_PORT'],
      user_name:            ENV['SMTP_USER_NAME'],
      password:             ENV['SMTP_PASSWORD'],
      authentication:       'plain',
      ssl:                  true,
      enable_starttls_auto: true
    }
  elsif [ENV['POSTAL_HOST'], ENV['POSTAL_SERVER_KEY']].all?(&:present?)
    config.action_mailer.delivery_method = :postal
    config.action_mailer.postal_settings = {
      host: ENV['POSTAL_HOST'],
      server_key: ENV['POSTAL_SERVER_KEY']
    }
  elsif ENV['SENDGRID_API_KEY'].present?
    config.action_mailer.delivery_method = :sendgrid_actionmailer
    config.action_mailer.sendgrid_actionmailer_settings = {
      api_key: ENV['SENDGRID_API_KEY']
    }
  else
    config.action_mailer.delivery_method = :letter_opener
  end

  RestClient.log = 'stdout'

end