class SearchController < ApplicationController
  before_filter :get_current_user

  def index
    @pagename = "Search"
    if request.post?
      if (params[:search][:string].blank?)
        flash[:notice] = "Please enter a search term"
        redirect_to :action => "index"
      end
      @users = User.find_public(params[:search][:string])
      @groups = Group.search(params[:search][:string])
      @pagename = "Search results"
    end
  end

end
