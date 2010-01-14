class MainController < ApplicationController
  prepend_before_filter :enable_mobile_mode, :only => [ :mobile ]
  before_filter :check_logged_in, :only => [ :mobile ]  
  before_filter :check_not_logged_in, :only => [ :index ]

  def index
    respond_to do |format|
      format.html
      format.iphone {render :layout => request.xhr? ? false : "application"}
    end
  end

  def mobile
    render :action => 'mobile', :layout => false
  end

end
