# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'sof'
set :repo_url, 'git@github.com:kairat-zhumaniyazov/sof.git'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deployer/sof'
set :deploy_user, 'deployer'

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
set :linked_files, %w{config/database.yml config/private_pub.yml config/private_pub_thin.yml .env}

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart
end

namespace :private_pub do
  desc 'Start private_pub server'
  task :start do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec thin -C config/private_pub_thin.yml start'
        end
      end
    end
  end

  desc 'Stop private_pub server'
  task :stop do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec thin -C config/private_pub_thin.yml stop'
        end
      end
    end
  end

  desc 'Retart private_pub server'
  task :restart do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec thin -C config/private_pub_thin.yml restart'
        end
      end
    end
  end
end

namespace :ts do
  desc 'Sphinx index'
  task :index do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec rake ts:index'
        end
      end
    end
  end

  desc 'Sphinx start'
  task :start do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec rake ts:start'
        end
      end
    end
  end

  desc 'Sphinx stop'
  task :stop do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec rake ts:stop'
        end
      end
    end
  end

  desc 'Sphinx restart'
  task :restart do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec rake ts:restart'
        end
      end
    end
  end
end

after 'deploy:restart', 'private_pub:restart'
