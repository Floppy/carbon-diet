require 'graph_functions'

class FriendsController < BelongsToUser
  before_filter :get_friend, :except => [:index, :send_invitations, :invite]

  include GraphFunctions

  def index
    respond_to do |format|
      format.html {
        # Generate league table
        @leaguetable = []
        @user.friends.each { |u| @leaguetable << { :user => u, :total => (u.annual_emissions > 0 and u.public) ? u.annual_emissions : 9e99 } }
        @leaguetable << { :user => @user, :total => @user.annual_emissions > 0 ? @user.annual_emissions : 9e99 }
        @leaguetable = @leaguetable.sort{ |x,y| x[:total] <=> y[:total] }
        # Generate pie chart URL
        @pie_url = user_friends_path(@user, :format => :xmlchart)
      }
      format.xmlchart {
        srand(42)
        # Store totals
        @totals = []
        @colours = []
        # Get friends
        friends = Array.new(@user.friends)
        friends << @user
        total = 0.0
        friends.each { |u| total += u.annual_emissions if u.public}
        # For each account, calculate emissions
        friends.each do |user|
          # Create totals
          @totals << {:name => user.name, :data => { :total => user.annual_emissions, :percentage => user.annual_emissions/total} } if user.public
          # Create colours
          @colours << random_colour
        end
        # Send data
        render :file => 'shared/pie', :layout => false
      }
    end
  end
 
  def update
    @user.add_friend(@friend)
    redirect_to user_friends_path(@user)
  end

  def destroy
    @user.remove_friend(@friend)
    redirect_to user_friends_path(@user)
  end

  def accept
    @user.approve_friend_request(@friend) rescue flash[:notice] = 'Unknown user'
    redirect_to user_friends_path(@user)
  end

  def reject
    @current_user.reject_friend_request(@friend) rescue flash[:notice] = 'Unknown user'
    redirect_to user_friends_path(@user)
  end

  def send_invitations
    unless verify_recaptcha
      flash[:notice] = 'Incorrect word verification! Please try again.'
      params[:recaptcha_response_field] = ""
      render :action => 'invite'
      return
    end
    sent = 0
    10.times do |i|
      email = params[:email]["user#{i}"]
      unless email.blank? or email !~ /^$|^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i        
        sent += 1 if UserMailer.deliver_friend_invitation(@current_user, email, params[:group][:id])
      end
    end
    if sent > 0
      flash[:notice] = "Invitations sent!"
    end
    redirect_to user_friends_path(@user)
  end

  def invite
    @group_list = [["",0]]
    @user.groups.each { |group| @group_list << [group.name, group.id] }
  end

  protected

  def get_friend
    @friend = User.find_by_login(params[:id])
  end

end

