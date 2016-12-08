require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ThalariondRails
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.mailer = YAML.load_file("#{Rails.root.to_s}/config/mailer.yml")[Rails.env]

    # Enable or disable email notifications
    config.enable_notifications_mailer = (Rails.env == 'production')

    # Add Bower assets, precompile fonts
    config.assets.paths << Rails.root.join('vendor', 'assets', 'components')
    config.assets.precompile << /\.(?:svg|eot|woff|woff2|ttf|otf)\z/

    config.autoload_paths += %W(#{config.root}/lib)

    # Customize Doorkeeper layout
    config.to_prepare do
      Doorkeeper::ApplicationsController.layout 'dashboard'
      Doorkeeper::AuthorizationsController.layout 'oauth2'
      Doorkeeper::AuthorizedApplicationsController.layout 'dashboard'
    end
  end
end
