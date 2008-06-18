class Admin::GroupsController < Admin::AdminController

  active_scaffold :groups do |config|
    config.columns = [:name, :description, :private, :owner]
    config.columns[:owner].ui_type = :select
  end
  
end
