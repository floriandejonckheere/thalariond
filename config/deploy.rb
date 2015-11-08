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