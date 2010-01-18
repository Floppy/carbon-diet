class MainController < ApplicationController

  def index
    redirecto_to_main_page if @current_user
    respond_to do |format|
      format.html
      format.iphone {render :layout => request.xhr? ? false : "application"}
      format.wml
    end
  end

  def mobile
    # Force mobile mode - allow escape though...
    session[:wap] = (params[:enable] == "false" ? nil : true)
    redirect_to_main_page
  end

end
