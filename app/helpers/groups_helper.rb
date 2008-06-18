module GroupsHelper

  def group_invite_link(invitation)
    render :partial => "group_invite_link", :locals => { :invitation => invitation }
  end

end
