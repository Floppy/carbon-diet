class HelpController < ApplicationController
  before_filter :get_current_user
  before_filter :check_logged_in, :only => [:country_request]
  
  def index
    respond_to do |format|
      format.html
      format.iphone { render_iphone }
      format.wml
    end
  end

  def country_request
    if request.post?
      # Send email with country request in it
      AdminMailer.ountry_request(@current_user, params[:country]).deliver
    end
  end

end
