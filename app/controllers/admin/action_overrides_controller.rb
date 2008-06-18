class Admin::ActionOverridesController < Admin::AdminController

  active_scaffold :action_overrides do |config|
    config.columns[:action].ui_type = :select
    config.columns[:country].ui_type = :select
  end

end
