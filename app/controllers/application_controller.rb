# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  include HoptoadNotifier::Catcher

  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_carbondiet_session_id'

  before_filter :detect_iphone

  helper_method :iphone_user_agent?

protected

  def get_current_user
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

  def enable_mobile_mode
    session[:mobile] = true
  end

  def redirect_to_main_page
    if session[:mobile]
      redirect_to(:controller => "/main", :action => "mobile")
    else
      redirect_to(:controller => "/profile")
    end  
  end

  def redirect_to_login_page
    if session[:mobile]
      redirect_to_mobile_login_page
    else
      redirect_to(:controller => "/main", :action => "index")
    end  
  end

  def redirect_to_mobile_login_page
    redirect_to(:controller => "/user", :action => "mobile_login")
  end
 
  def paginate_collection(collection, options = {})
    default_options = {:per_page => 10, :page => 1}
    options = default_options.merge options
    pages = Paginator.new self, collection.size, options[:per_page], options[:page]
    first = pages.current.offset
    last = [first + options[:per_page], collection.size].min
    slice = collection[first...last]
    return [pages, slice]
  end
  
  def get_actions(num, offset=0)
    return if @current_user.nil?
    totals = @current_user.calculate_totals(28)
    categories = []
    for item in totals
      if item[:name] != "Total"
        for category in item[:categories]
          categories << category unless categories.include?(category)
        end
      end
    end
    actions = Action.find_for_user(@current_user, categories, num, offset)
    # Load override content
    actions.each { |action| action.load_random_override(@current_user.country_id) }
  end

  def detect_iphone
    request.format = :iphone if iphone_user_agent?
  end

  def iphone_user_agent?
    request.env["HTTP_USER_AGENT"] &&  request.env["HTTP_USER_AGENT"][/(Mobile\/.+Safari)/]
  end

end
