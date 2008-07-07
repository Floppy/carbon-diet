class Admin::ActionsController < Admin::AdminController

  active_scaffold :actions do |config|
    config.columns = [:title, :content, :image, :level, :action_category]
    config.columns[:action_category].form_ui = :select
  end
  
end
