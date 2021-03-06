# Be sure to restart your server when you modify this file.

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '1.2.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here

  # Skip frameworks you're not going to use (only works if using vendor/rails)
  config.frameworks -= [ :active_resource ]

  # Only load the plugins named here, in the order given. By default all plugins in vendor/plugins are loaded, in alphabetical order
  # :all can be used as a placeholder for all plugins not explicitly named.
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]
  config.plugins = [ :acts_as_textiled, :has_many_polymorphs, :all ]

  # Add additional load paths for your own custom dirs
  config.load_paths += %W( #{RAILS_ROOT}/app/observers 
                           #{RAILS_ROOT}/app/mailers 
                           #{RAILS_ROOT}/app/managers
                           #{RAILS_ROOT}/app/presenters
                           #{RAILS_ROOT}/app/exceptions
                           #{RAILS_ROOT}/app/renderers )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  config.action_controller.session = {
    :session_key => '_strac_session',
    :secret      => 'f7d080d63358d983c335ba3cc540f6a6'
  }

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  config.active_record.observers = [ :story_observer, :comment_observer ] unless RAILS_ENV['test']

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc

  # See Rails::Configuration for more options

  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory is automatically loaded
  config.action_mailer.delivery_method = :sendmail
  
  # Add stuff in vendor/gems to load path
  config.load_paths += Dir["#{RAILS_ROOT}/vendor/gems/**"].map do |dir| 
    File.directory?(lib = "#{dir}/lib") ? lib : dir
  end
  
  # Load gems from local directory before using system wide gem repository
  case RUBY_PLATFORM
    when /darwin/
      platform_dir = "osx"
    when /win32/
      platform_dir = "win32"
    else
      platform_dir = "linux"
  end
  
  config.load_paths += Dir["#{RAILS_ROOT}/vendor/#{platform_dir}/gems/**"].map do |dir|
    # ruby-debug puts its main file in 'cli/' and not in 'lib/' so we accomodate here
    if dir =~ /ruby-debug-0.9.3$/
      File.directory?(lib = "#{dir}/cli") ? lib : dir
    else
      File.directory?(lib = "#{dir}/lib") ? lib : dir
    end
  end
end

require 'metaid'
require 'constructor'
