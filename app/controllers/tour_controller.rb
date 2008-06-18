class TourController < ApplicationController
  before_filter :get_current_user

  def index
    render :action => '1'
  end

end
