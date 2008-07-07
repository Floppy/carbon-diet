class Admin::UserController < Admin::AdminController
 
  active_scaffold :users do |config|
    config.actions.exclude :create
    config.columns[:country].form_ui = :select
    config.list.columns = [:login, :email, :display_name, :public, :country, :tester, :last_login_at]
    config.show.columns = [:login, :email, :display_name, :public, :country, :tester, :admin, :has_avatar, :reminder_frequency, :people_in_household, :annual_emission_total, :notify_friend_requests, :notify_profile_comments, :guid, :created_at, :updated_at, :last_login_at, :reminded_at ]
    config.update.columns = [:login, :email, :display_name, :public, :country, :tester, :admin, :has_avatar, :reminder_frequency, :people_in_household, :annual_emission_total, :notify_friend_requests, :notify_profile_comments]
  end  
  
end
