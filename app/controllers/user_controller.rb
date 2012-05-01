class UserController < ApplicationController
  before_filter :check_logged_in, :only => [ :logout, :set_login, :edit, :update, :destroy, :really_destroy, :resend_confirmation ]  
  before_filter :check_not_logged_in, :except => [ :logout, :set_login, :edit, :update, :destroy, :really_destroy, :resend_confirmation, :confirm_email ]
  before_filter :check_form_data, :only => [:auth]
  #filter_parameter_logging :password
  
  #verify :method => :post, 
  #       :only => [:doreset, :signup, :auth, :really_destroy, :update], 
  #       :redirect_to => { :action => :login }

private

  def check_form_data
    if params[:user].nil?
      redirect_to_main_page
      return false
    elsif not params[:user][:login] =~ /^\w+$/i and not params[:user][:login] =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
      flash[:notice] = "Please enter a valid username (letters, numbers and underscores only)"
      redirect_to_login_page
      return false
    elsif params[:user][:password].blank?
      flash[:notice] = "Please enter a password"
      redirect_to_login_page
      return false
    end
  end

public

  # Default action is edit
  def index
    redirect_to :action => "edit"
  end
  
  def resetpw
  end

  def change_password
  end

  def login
    redirect_to :controller => "/main", :action => "index"
  end

  def logout
    cookies[:login_token] = nil
    @current_user.clear_login_key! if @current_user
    wap = session[:wap]
    reset_session
    session[:wap] = wap
    redirect_to_login_page
  end

  def auth
    # Find user and check password
    result = User.authenticate(params[:user][:login], params[:user][:password])
    if result == :no_such_user
      if mobile?
        flash[:notice] = "Unknown username entered."
        redirect_to_login_page
      else
        # Username not found - go to new account creation area
        reset_session
        # Check that we have a valid username, not an email address - only needed until switchover is complete
        if params[:user][:login] =~ /^\w+$/i
          # Store login and password in session ready for confirmation
          session[:login] = params[:user][:login]
          session[:password] = params[:user][:password]
          # Go to confirmation
          redirect_to(:action => "confirm", :params => {:invite => params[:invite], :group => params[:group]})
        else
          flash[:notice] = "Please enter a valid username (letters, numbers and underscores only)"
          redirect_to_login_page
        end
      end
    elsif result == :wrong_password
      # Notify user of incorrect password   
      flash[:notice] = "Incorrect password entered."
      flash[:notice] += "If you were trying to create a new account, the username you used is already registered." if not mobile?
      redirect_to_login_page
    elsif result == :logged_in_using_email
      # Notify user that email login isn't allowed any more
      flash[:notice] = "You can't log in with your email address any more. Please log in with your new username instead."
      redirect_to_login_page
    else
      # Get user
      user = User.find_by_id(result)
      # Set login cookie
      cookies[:login_token]= {:value => "#{user.id};#{user.reset_login_key!}", :expires => Time.now.utc+1.year} if params[:user][:remember] == "1"
      # Store user ID in session
      session[:user_id] = result
      # Store last login time
      user.last_login_at = Time.now
      user.save! unless user.login.blank? or user.login.nil?
      # Redirect on the next stage...
      if user.login.blank? or user.login.nil?
        # Login hasn't been defined yet - make the user choose one.
        redirect_to :action => 'set_login'
      elsif session[:intended_action] and session[:intended_controller]
        # Redirect to main page
        redirect_to(:controller => session[:intended_controller], :action => session[:intended_action], :params => session[:intended_params])
      elsif session[:next]
        if session[:next].include? "http://support.carbondiet.org"
          redirect_to "#{session[:next]}?sso=#{CGI.escape(user.multipass)}"
        else
          redirect_to(session[:next])
        end
      else
        redirect_to_main_page
      end    
    end
  end

  def set_login
    user = @current_user
    if request.post?
      if not params[:user][:login] =~ /^\w+$/i
        flash[:notice] = "Please enter a valid username (letters, numbers and underscores only)"
      else
        user.login = params[:user][:login]
        user.last_login_at = Time.now
        if user.save
          redirect_to_main_page
        else
          flash[:notice] = "That username is already taken, sorry! Please choose another."
        end
      end
    end
  end

  def confirm  
    # Create captcha seed and store in session
    #session[:captcha] = generate_captcha_id
    # Generate captcha URL for view
    #@captcha_image = generate_captcha_url(session[:captcha])
  end

  def signup
    # Confirm password
    if session[:password] != params[:user][:password_confirmation]
      flash[:notice] = "Passwords did not match, please check and try again"
    # Everything checks out...
    else
      # Create account
      user = User.new
      user.login = session[:login]
      user.password = session[:password]
      user.save
      session[:password] = nil
      session[:login] = nil
      # Send a new user signup notification to the admin
      AdminMailer.deliver_new_signup(user.login)
      # Auto-add friends and groups
      if params[:invite]
        friend = User.find(params[:invite]) rescue nil
        user.add_friend(friend) if friend
      end
      if params[:group]
        group = Group.find(params[:group]) rescue nil
        group.add_user(user) if group
      end
      # Log the user in
      session[:user_id] = user.id 
      # Store last login time
      user.last_login_at = Time.now
      user.save!
      @confirmed = true
      flash[:notice] = "Welcome to the Carbon Diet! You're now fully signed in, so you can go ahead and start using the site. Have fun!"
  	 	redirect_to :action => "edit"
  	 	return
    end
    redirect_to_login_page
  end

  def confirm_email
    # Find user by confirmation code
    user = User.find_by_confirmation_code(params[:id])
    unless user.nil?
      # Clear confirmation code
      user.confirmation_code = nil
      user.save!
      flash[:notice] = "Email address confirmed!"
    else
      flash[:notice] = "Unknown confirmation code!"
    end
    redirect_to_login_page
  end

  def doreset
    user = User.find_by_login(params[:user][:login].downcase)
    if user.nil?
      flash[:notice] = "Username not found!"
    elsif not user.confirmed_email.nil?
      user.reset_password
      UserMailer.deliver_password_change(user.confirmed_email, url_for(:action => 'change_password', :code => user.password_change_code))
      flash[:notice] = "Instructions for changing your password have been sent to you via email."
    else
      flash[:notice] = "Unfortunately, we don't have your email address on file! Please send us a message via the help button above and we will sort you out."
    end
    redirect_to_login_page
  end

  def do_change
    if params[:user][:code].blank? 
      flash[:notice] = "No password change code provided!"
    else
      user = User.find_by_password_change_code(params[:user][:code])
      if user.nil?
        flash[:notice] = "User not found!"
      elsif params[:user][:login] != user.login
        flash[:notice] = "Username not confirmed correctly, please check and try again"
      elsif params[:user][:password] != params[:user][:password_confirmation]
        flash[:notice] = "Passwords did not match, please check and try again"
      else
        user.password = params[:user][:password]
        user.save
        flash[:notice] = "Password was changed. You can now log in!"
      end
    end
    redirect_to_login_page
  end

  def edit
    @user = @current_user
    @countries = Country.find(:all, :conditions => ["visible IS TRUE"], :order => "name")
  end
 
  def update
    unless @current_user.update_attributes(params[:user])
      flash[:notice] = 'Couldn\'t save settings'
      redirect_to :action => 'edit'
      return
    end
    # Store new password if set
    unless params[:user][:new_password].blank?
      if params[:user][:new_password] == params[:user][:new_password_confirmation]      
        @current_user.password = params[:user][:new_password]
      else
        flash[:notice] = 'Password not confirmed correctly! Please try again!'
        redirect_to :action => 'edit'
        return
      end
    end
    # Store avatar manually - doesn't automatically happen in update_attributes
    begin
      @current_user.avatar = params[:user][:avatar]
    rescue
      flash[:notice] = 'Image upload failed! Please check that you are uploading a valid image file!'
      redirect_to :action => 'edit'
      return    
    end
    # Done
    redirect_to_main_page
  end

  def destroy
  end

  def really_destroy
    @current_user.destroy
    @current_user = nil
    logout
  end
  
  def resend_confirmation
    flash[:notice] = 'Confirmation email resent! Check your email!'
    UserMailer.deliver_email_confirmation(@current_user) if @current_user.confirmation_code
    redirect_to_main_page
  end  
  
end
