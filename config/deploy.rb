require 'mongrel_cluster/recipes'

set :application, 'carbon-diet'

set :scm, "git"
set :repository, 'git@code.atechlabs.com:carbon-diet.git'
set :deploy_via, :export

set :deploy_to, '/home/carbondiet'
set :user, 'carbondiet'

role :app, '67.207.136.20'
role :web, '67.207.136.20'
role :db,  '67.207.136.20', :primary => true

set :mongrel_conf, "#{current_path}/config/mongrel_cluster.yml"

after "deploy:update_code", "symlink:avatars", "symlink:dbconfig"

namespace :symlink do
  desc "Symlink the avatars folder."
  task :avatars do
    run "ln -fs #{shared_path}/avatars #{release_path}/public/images"
  end
  desc "Make copy of database yaml" 
  task :dbconfig do
    run "cp #{shared_path}/config/database.yml #{release_path}/config/database.yml" 
  end

end