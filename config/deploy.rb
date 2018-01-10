# config valid only for current version of Capistrano
lock '3.5.0'

set :repo_url, 'https://github.com/alerkasun/gas-powered-app'
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

set :user, 'root'
set :application, 'gas-powered-app'
set :rails_env, 'production'
server '185.198.164.218', user: fetch(:user), roles: %w(web app db), port: 3333, password: 'ZUfuTEc5'

set :deploy_to,       "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :pty, true

set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml', 'config/puma.rb')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

set :config_example_suffix, '.example'
set :config_files, %w{config/database.yml config/secrets.yml}
set :puma_conf, "#{shared_path}/config/puma.rb"

namespace :deploy do
  before 'check:linked_files', 'config:push'
  before 'check:linked_files', 'puma:config'
  before 'check:linked_files', 'puma:nginx_config'
  before 'deploy:migrate', 'deploy:db:create'
  after 'puma:smart_restart', 'nginx:restart'
end
