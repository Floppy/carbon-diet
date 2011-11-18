RailsAdmin.config do |config|
  
  config.current_user_method { get_current_user }
  
  config.main_app_name = ['Carbon Diet', 'Admin']

  RailsAdmin.config do |config|
    config.authenticate_with do
      check_logged_in
    end
  end

  # Or use simple custom authorization rule:
  config.authorize_with do
    redirect_to root_path unless get_current_user.admin
  end

end
