class Admin::GroupMembershipsController < Admin::AdminController

  active_scaffold :group_memberships do |config|
    config.columns[:group].ui_type = :select
    config.columns[:user].ui_type = :select
  end
  
end
