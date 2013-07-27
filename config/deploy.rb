require "bundler/capistrano"
require 'rvm/capistrano'

ssh_options[:forward_agent] = true
set :application, 'memoryjar'
set :rvm_ruby_string, "2.0.0@#{application}"
set :rvm_type, :user

set :scm, :git
set :deploy_via, :remote_cache

set :repository, "git@bigpurplefish.co.uk:#{application}.git"

set :deploy_to, "/srv/websites/#{application}"

set :use_sudo, false
set :user, 'rails'

server '31.222.164.148', :app, :web, :db, :primary => true

namespace :deploy do
  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
      from = source.next_revision(current_revision)
      if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
        run "cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile"
      else
        logger.info "Skipping asset pre-compilation because there were no asset changes"
      end
    end
  end
  
  task :start, :roles => :app do
    run "cd #{current_release}; script/server start"
  end

  task :stop, :roles => :app do
    run "cd #{current_release}; script/server stop"
  end
  
  desc 'Restart Application'
  task :restart, :roles => :app do
    run "cd #{current_release}; script/server reload-app"
  end
  
  desc 'Symlink folders on each release.'
  task :symlink_shared do
    run "ln -nfs #{File.join(shared_path, 'config', 'database.yml')} #{File.join(release_path,'config','database.yml')}"
    run "ln -nfs #{shared_path}/uploads #{release_path}/public/uploads"
  end
  
  namespace :db do 
    desc 'Reset the database.'
    task :setup do
      run "cd #{current_release}; RAILS_ENV=production bundle exec rake db:setup"
    end
    
    desc 'Seed the database.'
    task :seed do
      run "cd #{current_release}; RAILS_ENV=production bundle exec rake db:seed"
    end
  end
  
  namespace :server do
    desc 'Reload the config files'
    task :reload do
      run "#{try_sudo} service nginx reload"
    end
    
    desc 'Restart the server'
    task :restart do
      run "#{try_sudo} service nginx restart"
    end
  end
end

before 'deploy:assets:precompile', 'deploy:symlink_shared'
after 'deploy', 'deploy:cleanup'
