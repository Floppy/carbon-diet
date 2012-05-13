module ProfileHelper

  def news_feed(user, limit=10)
    feed = []
    # Get electricity reading data
    user.electricity_readings.limit(limit).order("taken_on DESC").where(:automatic => false).each do |reading|
      feed << {:image => 'electricity.png', 
               :when => reading.taken_on.to_time, 
               :text => "took a reading for '" + h(reading.electricity_account.name) + "'"}
    end
    # Get gas reading data
    user.gas_readings.limit(limit).order("taken_on DESC").each do |reading|
      feed << {:image => 'gas.png', 
               :when => reading.taken_on.to_time, 
               :text => "took a reading for '" + h(reading.gas_account.name) + "'"}
    end
    # Get fuel purchase data
    user.vehicle_fuel_purchases.limit(limit).order("purchased_on DESC").each do |purchase|
      feed << {:image => 'car.png', 
               :when => purchase.purchased_on.to_time, 
               :text => "bought some fuel for '" + h(purchase.vehicle.name) + "'"}
    end
    # Get completed action data
    user.completed_actions.limit(limit).order("created_at DESC").where(:done => true).each do |action|
      feed << {:image => 'action.png', 
               :when => action.created_at, 
               :text => "agreed to do the action " + link_to(h(action.action.title), :controller => "/actions", :action => 'view', :id => action.action.id)}
    end
    # Get friends data
    user.approved_friendships.limit(limit).order("created_at DESC").each do |friendship|
      feed << {:image => 'user.png', 
               :when => friendship.created_at, 
               :text => "made friends with " + (friendship.friend.public ? link_to(h(friendship.friend.name), :controller => "/profile", :login => friendship.friend.login) : h(friendship.friend.name))}
    end
    # Get groups data
    user.group_memberships.limit(limit).order("created_at DESC").each do |group|
      feed << {:image => 'group.png', 
               :when => group.created_at, 
               :text => "joined the group " + link_to(h(group.group.name), group_path(group.group))}
    end
    # Get note data
    user.all_notes(limit).each do |note|
      feed << {:image => 'note.png', 
               :when => note.date.to_time,
               :text => "wrote a note: '" + h(note.note) + "'"}
    end
    # Get comment data
    user.authored_comments.limit(limit).order("created_at DESC").where("NOT (commentable_type = 'User' AND commentable_id = ?)", user.id).each do |comment|
      case comment.commentable_type
      when "User"
        name = comment.commentable == user ? "his" : comment.commentable.name + "'s"
        text = "wrote a comment on " + (comment.commentable.public ? link_to(h(name), :controller => "/profile", :login => comment.commentable.login, :anchor => "comment#{comment.id}") : h(name)) + " profile"
      when "Group"
        text = "wrote a comment in the " + link_to(h(comment.commentable.name), group_path(comment.commentable, :anchor => "comment#{comment.id}")) + " group"
      else
        raise "Unknown commentable type!"
      end
      feed << {:image => 'comment.png', 
               :when => comment.created_at.to_time,
               :text => text}
    end
    # Get comment data
    user.comments.limit(limit).order("created_at DESC").each do |comment|
      text = ""
      if comment.user != user 
        text += (comment.user.public ? link_to(h(comment.user.name), :controller => "/profile", :login => comment.user.login) : h(comment.user.name)) + ' '
      end
      text += "wrote a "
      text += link_to('comment', :anchor => "comment#{comment.id}")
      text += " on this profile"
      feed << {:image => 'comment.png', 
               :when => comment.created_at.to_time,
               :text => text}
    end
    # Sort by date
    return feed.sort{ |x,y| y[:when] <=> x[:when] }.first(limit)
  end
  
end
