# config valid only for Capistrano 3.1
lock '3.1.0'

set :user, 'deployer'
set :use_sudo, false

set :application, 'simply'
set :repo_url, 'https://github.com/lanvige/simply.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
set :deploy_to, "/home/#{fetch :user}/apps/#{fetch :application}"

# Default value for :scm is :git
set :scm, :git

# Config for rbenv on server.
set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.1.0'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value


set :format, :pretty
set :log_level, :debug
set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

set :keep_releases, 5

namespace :deploy do

  desc "setup unicorn"
  task :setup_config do
    on roles(:app) do
      execute "echo 'ss'"
      execute "#{sudo} ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{fetch :application}"
      # execute "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
      # execute "mkdir -p #{shared_path}/config"
      # put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
      # puts "Now edit the config files in #{shared_path}."
    end
  end

  # after "deploy:setup", "deploy:setup_config"
  # after 'deploy:updated', 'deploy:db_migrate'

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'
end
