class Admin::CountryController < Admin::AdminController

  active_scaffold :countries do |config|
    config.columns = [:name, :abbreviation, :flag_image, :visible]
  end

end
