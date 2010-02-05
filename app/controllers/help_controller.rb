class HelpController < ApplicationController
  before_filter :get_current_user
  before_filter :check_logged_in, :only => [:country_request]
  
  def index
    @pagename = "Help"
    respond_to do |format|
      format.html
      format.iphone { render_iphone }
      format.wml
    end
  end

  def country_request
    if request.post?
      # Send email with country request in it
      AdminMailer.deliver_country_request(@current_user, params[:country])
    end
  end

end
