class Admin::ActionCategoriesController < Admin::AdminController

  active_scaffold :action_categories do |config|
    config.columns = [:name, :image]
  end
  
end
