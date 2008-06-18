class Admin::FriendshipsController < Admin::AdminController

  active_scaffold :friendships do |config|
    config.columns[:friend].ui_type = :select
    config.columns[:user].ui_type = :select
  end
  
end
