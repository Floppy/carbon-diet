require 'mongrel_cluster/recipes'

set :application, 'carbondiet'

set :repository,  'https://floppy.plus.com/svn/carbondiet/carbondiet/trunk/'
set :deploy_via,   :remote_cache

set :deploy_to, '/home/carbondiet'
set :user, 'carbondiet'

role :app, '67.207.136.20'
role :web, '67.207.136.20'
role :db,  '67.207.136.20', :primary => true

set :mongrel_conf, "#{current_path}/config/mongrel_cluster.yml"

after "deploy:update_code", "symlink:avatars"

namespace :symlink do
  desc "Symlink the avatars folder."
  task :avatars do
    run "ln -fs #{shared_path}/avatars #{release_path}/public/images"
  end
end