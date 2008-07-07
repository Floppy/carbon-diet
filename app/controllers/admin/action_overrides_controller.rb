class Admin::ActionOverridesController < Admin::AdminController

  active_scaffold :action_overrides do |config|
    config.columns[:action].form_ui = :select
    config.columns[:country].form_ui = :select
  end

end
