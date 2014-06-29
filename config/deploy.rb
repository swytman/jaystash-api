# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'jaystash-api'
set :repo_url, 'https://github.com/swytman/jaystash-api.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/var/www/jaystash-api'
set :current_path,  "#{fetch(:deploy_to)}/current"
set :unicorn_conf, "#{fetch(:deploy_to)}/current/config/unicorn/#{fetch(:stage)}.rb"
set :unicorn_pid, "#{fetch(:deploy_to)}/shared/pids/unicorn.pid"



# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
#set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :unicorn do

  task :restart do
    on roles :all do
      #execute "if [ -f #{fetch(:unicorn_pid)} ]; then disown `cat #{fetch(:unicorn_pid)} && kill -QUIT `cat #{fetch(:unicorn_pid)}`; fi"
      execute "if [ -f #{fetch(:unicorn_pid)} && ps -p `cat #{fetch(:unicorn_pid)}` ]; then disown `cat #{fetch(:unicorn_pid)}` && kill -USR2 `cat #{fetch(:unicorn_pid)}`; else cd #{fetch(:current_path)} && bundle exec unicorn -c #{fetch(:unicorn_conf)} -E #{fetch(:stage)} -D; fi"
    end
  end

  task :start do
    on roles :all do
      execute "cd #{fetch(:current_path)} && bundle exec unicorn -c #{fetch(:unicorn_conf)} -E #{fetch(:stage)} -D"
    end
  end

  task :stop do
    on roles :all do
      execute "if [ -f #{fetch(:unicorn_pid)} ]; then kill -QUIT `cat #{fetch(:unicorn_pid)}`; fi"
    end
  end

end

after 'deploy:publishing', 'unicorn:restart'

