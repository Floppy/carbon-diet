module FriendsHelper

  def approve_friend_link(user)
    render :partial => "approve_friend_link", :locals => { :user => user }
  end

end
