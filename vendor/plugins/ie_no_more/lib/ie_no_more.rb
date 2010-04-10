# IeNoMore

module IENoMore
  
  def smack_down_ie6
    render :partial => "ie_no_more/ie_upgrade_message" if is_ie6? && !cookie_set?
  end
  
  def hide_if_ie6
    yield unless is_ie6?
  end
  
  def show_if_ie6
    yield if is_ie6?
  end
  
  def is_ie6?
    request.env["HTTP_USER_AGENT"] =~ /MSIE 6+?/
  end
  
  private
    def cookie_set?
      cookies[:hide_ie_no_more_message] == '1'
    end
    
end