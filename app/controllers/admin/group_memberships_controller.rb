class Admin::GroupMembershipsController < Admin::AdminController

  active_scaffold :group_memberships do |config|
    config.columns[:group].form_ui = :select
    config.columns[:user].form_ui = :select
  end
  
end
