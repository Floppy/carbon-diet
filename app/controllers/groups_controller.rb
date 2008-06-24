class GroupsController < ApplicationController
  before_filter :get_current_user, :only => ["view", "browse", "feed"]
  before_filter :check_logged_in, :except => ["view", "browse", "feed"]

  verify :method => :post, :only => ['destroy']

  def index
    redirect_to :action => 'list'
    return
  end
 
  def list
    @pagename = "My Groups"
    @groups = @current_user.groups
  end
  
  def browse
    @pagename = "Browse Groups"
    @subsections, @groups =  Group.browse(params[:string])
  end
 
  def view
    @group = Group.find_by_id(params[:id])
    @pagename = @group.name
    @comments = @group.comments
    # Generate league table
    @leaguetable = []
    @group.users.each { |u| @leaguetable << { :user => u, :total => (u.annual_emissions > 0 and u.public) ? u.annual_emissions : 9e99 } }
    @leaguetable = @leaguetable.sort{ |x,y| x[:total] <=> y[:total] }
    # Generate pie chart URL
    @pie_url = url_for(:controller => "xml_chart", :action => "pie_group", :id => @group.id)    
  rescue
    flash[:notice] = "Unknown group!"
    index
  end

  def edit
    @group = params[:id] ? Group.find_by_id(params[:id]) : Group.new
    index if (@group.owner && @group.owner != @current_user)
    if request.post?      
      if verify_recaptcha(@group)
        @group.update_attributes(params[:group])
        if @group.owner.nil?
         @group.owner = @current_user
        end
        redirect_to :action => 'view', :id => @group if @group.save
      end
    end
    # Set page name
    if params[:id]
      @pagename = "Editing " + @group.name
    else
      @pagename = "Create a new group"
    end
  end

  def destroy
    group = @current_user.owned_groups.find(params[:id])
    group.destroy
    index
  rescue
    flash[:notice] = "Unknown group!"
    index
  end

  def join
    group = Group.find_by_id(params[:id], :conditions => ["private IS FALSE"])
    group.add_user(@current_user)
    redirect_to :action => 'view', :id => params[:id]
  rescue
    flash[:notice] = "Unknown or private group!"    
    redirect_to :action => 'list'
  end

  def leave
    group = Group.find(params[:id]) rescue flash[:notice] = "Unknown group!"
    unless group.nil?
      group.remove_user(@current_user)
    end
    redirect_to :action => 'view', :id => params[:id]
  end
 
  def invite
    @group = @current_user.groups.find(params[:id]) 
    @friends = Array.new(@current_user.friends)
    for user in @group.users
      @friends.delete(user) 
    end
  rescue
    flash[:notice] = "Unknown group!"    
    redirect_to :action => 'list'
  end

  def send_invitations
    group = @current_user.groups.find(params[:id]) 
    for friend in @current_user.friends
      if params[:invite][friend.login] == "1"
        # Create invitation - automatically notifies the invited person
        GroupInvitation.create(:user => friend, :inviter => @current_user, :group => group)
      end
    end
    flash[:notice] = "Invitations sent!"
    redirect_to :action => 'view', :id => params[:id]
  rescue
    flash[:notice] = "Unknown group!"
    redirect_to :action => 'list'
  end

  def invite_accept
    invitation = @current_user.group_invitations.find(params[:id])
    invitation.accept
    redirect_to :action => 'list'
  rescue
    flash[:notice] = "Unknown invitation ID!"
    redirect_to :action => 'list'
  end
  
  def invite_reject
    invitation = @current_user.group_invitations.find(params[:id])
    invitation.reject
    redirect_to :action => 'list'
  rescue
    flash[:notice] = "Unknown invitation ID!"
    redirect_to :action => 'list'
  end

  def feed
    @group = Group.find_by_id(params[:id])
    @comments = @group.comments.find(:all, :order => "created_at DESC", :limit => 10)
    # Send data
    headers["Content-Type"] = "application/atom+xml"
    render :action => 'atom.rxml', :layout => false
  end

end
