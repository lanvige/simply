# config valid only for Capistrano 3.1
lock '3.1.0'

set :user, 'deployer'
set :use_sudo, false

set :application, 'simply'
set :scm, :git
set :branch, 'master'
set :keep_releases, 5
set :repo_url, 'https://github.com/lanvige/simply.git'
set :deploy_to, "/home/#{fetch :user}/apps/#{fetch :application}"

# log
set :format, :pretty
set :log_level, :info

set :pty, true



# Config for rbenv on server.
set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.1.0'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value
# set :default_env, { path: "/opt/ruby/bin:$PATH" }


# 把文件从shared里放入current目录里？why????
set :linked_files, %w{config/database.yml config/application.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
# 把文件从本地复制到服务器上？
# remote_file 'config/test.conf' => 'config/test1.conf', roles: :app


namespace :deploy do

  desc "setup unicorn"
  task :setup_config do
    on roles(:app) do
      execute :sudo, "echo 'ss'"
      execute :sudo, "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{fetch :application}"
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
