class Admin::FriendshipsController < Admin::AdminController

  active_scaffold :friendships do |config|
    config.columns[:friend].form_ui = :select
    config.columns[:user].form_ui = :select
  end
  
end
