# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'thalariond'
set :repo_url, 'git@github.com:floriandejonckheere/thalariond.git'

# Default branch is :master
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
# set :branch, '1-0-stable'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/opt/thalariond/thalariond/'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# capistrano-upload-config
set :config_example_suffix, '-example'

# Upload config
before 'deploy:check:linked_files', 'config:push'

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml', 'config/ldap.yml', 'config/mailer.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# SSH deployment keys
set :ssh_options, {:keys => [File.join(ENV['HOME'], '.ssh', 'thalariond@thalarion.be')]}

# Bundler options
set :bundle_bins, fetch(:bundle_bins, []).push('ldapd_ctl')

# RVM options
set :rvm_ruby_version, '2.2.3@thalariond-production'

# Puma options
  #~ set :puma_user, fetch(:user)
  #~ set :puma_rackup, -> { File.join(current_path, 'config.ru') }
  #~ set :puma_state, "#{shared_path}/tmp/pids/puma.state"
  #~ set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
  #~ set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"    #accept array for multi-bind
  #~ set :puma_default_control_app, "unix://#{shared_path}/tmp/sockets/pumactl.sock"
  #~ set :puma_conf, "#{shared_path}/puma.rb"
  #~ set :puma_access_log, "#{shared_path}/log/puma_access.log"
  #~ set :puma_error_log, "#{shared_path}/log/puma_error.log"
  #~ set :puma_role, :app
  #~ set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
  #~ set :puma_threads, [0, 16]
  #~ set :puma_workers, 0
  #~ set :puma_worker_timeout, nil
  #~ set :puma_init_active_record, false
  #~ set :puma_preload_app, true
  #~ set :nginx_use_ssl, false

# Capistrano Rails

# Defaults to [:web]
set :assets_roles, [:app]

# Defaults to nil (no asset cleanup is performed)
# If you use Rails 4+ and you'd like to clean up old assets after each deploy,
# set this to the number of versions to keep
set :keep_assets, 2

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :setup do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
      execute "mkdir #{shared_path}/log -p"
    end
  end

  before :start, :setup
end

namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end

namespace :ldapd do
  desc 'Print LDAP server status'
  task :status do
    on roles(:app), :except => { :no_release => true } do
      within "#{fetch(:deploy_to)}/current/" do
        with RAILS_ENV: fetch(:environment) do
          execute :bundle, "exec lib/daemons/ldapd_ctl status", raise_on_non_zero_exit: false
        end
      end
    end
  end

  desc 'Stop LDAP server'
  task :stop do
    on roles(:app), :except => { :no_release => true } do
      within "#{fetch(:deploy_to)}/current/" do
        with RAILS_ENV: fetch(:environment) do
          execute :bundle, "exec lib/daemons/ldapd_ctl stop"
        end
      end
    end
  end

  desc 'Start LDAP server'
  task :start do
    on roles(:app), :except => { :no_release => true } do
      within "#{fetch(:deploy_to)}/current/" do
        with RAILS_ENV: fetch(:rails_env) do
          execute :bundle, "exec lib/daemons/ldapd_ctl start"
        end
      end
    end
  end

end

before :deploy, "ldapd:stop"
after :deploy, "ldapd:start"
