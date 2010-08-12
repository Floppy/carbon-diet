# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base

  before_filter :detect_mobile_platforms

  helper_method :iphone?
  helper_method :wap?
  helper_method :mobile?

protected

  def get_current_user
    return @current_user if @current_user
    if session[:user_id]
      @current_user = User.find_by_id(session[:user_id])
      # If we have a user ID with no user attached, reset session
      unless @current_user
        reset_session
      end      
    elsif cookies[:login_token]
      @current_user = User.find_by_id_and_login_key(*cookies[:login_token].split(";"))
      unless @current_user.nil?
        session[:user_id] = @current_user.id
        @current_user.last_login_at = Time.now
        @current_user.save!
      end
    else
      @current_user = nil
    end
    return @current_user
  end

  def check_logged_in
    unless get_current_user
      session[:intended_action] = action_name
      session[:intended_controller] = controller_name
      session[:intended_params] = params
      redirect_to_login_page
      return false
    end
  end

  def check_not_logged_in
    if get_current_user
      redirect_to_main_page      
      return false
    end
  end

  def redirect_to_main_page
    if get_current_user
      redirect_to(:controller => "/profile")
    else
      redirect_to(:controller => "/main", :action => "index")
    end
  end

  def redirect_to_login_page
    redirect_to(:controller => "/main", :action => "index")
  end

  def get_actions(num, offset=0)
    return if @current_user.nil?
    totals = @current_user.calculate_totals(28)
    categories = []
    totals.each do |item|
      if item[:name] != "Total"
        item[:categories].each do |category|
          categories << category unless categories.include?(category)
        end
      end
    end
    actions = Action.find_for_user(@current_user, categories, num, offset)
    # Load override content
    actions.each { |action| action.load_random_override(@current_user.country_id) }
  end

  def detect_mobile_platforms
    if iphone?
      request.format = :iphone
      session[:wap] = nil # Kill the WAP session variable
    elsif wap?
      request.format = :wml
    end
  end

  def iphone?
    request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(Mobile\/.+Safari)/]
  end

  def render_iphone(options = {})
    options[:layout] ||= false
    render options
  end

  def wap?
    # If a browser explicitly asks for wap/wml, give it to them - also allow manual override using session
    session[:wap].present? || request.accepts.each.detect{|x| x.to_s == "text/vnd.wap.wml"}.present?
  end

  def mobile?
    iphone? || wap?
  end

  def render_http_code(code)
    @code = code
    render :status => code, :file => File.join(RAILS_ROOT, 'public', "#{code}.html")
  end

end
