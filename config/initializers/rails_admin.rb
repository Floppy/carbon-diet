RailsAdmin.config do |config|
  
  config.current_user_method { get_current_user }
  
  config.authenticate_with do
    check_logged_in
  end

  config.authorize_with do
    redirect_to root_path unless get_current_user.admin
  end

end

# WillPaginate fix from https://github.com/sferik/rails_admin/issues/816
if defined?(WillPaginate)
  module WillPaginate
    module ActiveRecord
      module RelationMethods
        alias_method :per, :per_page
        alias_method :num_pages, :total_pages
        alias_method :total_count, :count
      end
    end
  end
end