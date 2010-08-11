class IeHideMessagesController < ApplicationController
  # This is used to close the message and hide it forever.
  def create
    cookies[:hide_ie_no_more_message] = '1'
    
    respond_to do |format|
      format.js { render :nothing => true }
    end
  end
  
end