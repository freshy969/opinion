set :application, "opinion"
set :repository,  "git@github.com:Shopify/opinion.git"
set :branch,      "origin/master"
set :scm,         :git
set :deploy_via,  :fast_remote_cache
set :announce_in, "https://bot@jadedpixel.com:hallo28@jadedpixel.campfirenow.com/room/100257"
set :user,        "deploy"
set :rails_env,   "production"

role :app, "forums.cloud.shopify.com"
role :web, "forums.cloud.shopify.com"
role :db,  "forums.cloud.shopify.com", :primary => true

namespace :gems do     
  task :install, :roles => :app do
    run "cd #{release_path} && sudo rake RAILS_ENV=#{rails_env} gems:install"
  end
end

namespace :deploy do
  task :link_configs do        
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end

  desc "Signal Passenger to restart the application"
  task :restart, :roles => :app do
    run "touch #{release_path}/tmp/restart.txt"
  end
end

after "deploy:update_code", "deploy:link_configs", "gems:install", "deploy:migrate"