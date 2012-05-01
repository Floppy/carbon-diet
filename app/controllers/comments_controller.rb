class CommentsController < AuthenticatedController
  #verify :method => :post, :only => [ :post ], :redirect_to => { :controller => "main", :action => "index" }

  def post
    # Create comment
    comment = Comment.new
    comment.commentable_type =  params[:comment][:commentable_type]
    case comment.commentable_type
    when "User"
      comment.commentable_id = ((params[:comment][:commentable_id].to_i == @current_user.id) ? @current_user.id : @current_user.friends.find_by_id(params[:comment][:commentable_id]).id)
    when "Group"
      comment.commentable_id = @current_user.groups.find_by_id(params[:comment][:commentable_id]).id
    else
      raise "argh"
    end
    comment.update_attributes params[:comment]
    comment.user = @current_user
    comment.save!
    # Notify user if a comment has been posted on a profile
    if ((comment.commentable_type == "User") && (comment.commentable_id != @current_user.id))
      notify_user = User.find_by_id(comment.commentable_id)
      if notify_user.notify_profile_comments && notify_user.confirmed_email
        UserMailer.deliver_comment_notification(notify_user, @current_user)
      end
    end
    # Redirect
    case params[:comment][:commentable_type]
    when "User"
      redirect_to :controller => "profile", :login => User.find(params[:comment][:commentable_id]).login, :anchor => "comments"
    when "Group"
      redirect_to group_path(comment.commentable, :anchor => "comments")
    else
      redirect_to_main_page
    end    
  rescue
    flash[:notice] = "Couldn't post comment!"
    redirect_to_main_page
  end

  def delete
    # Find comment
    comment = @current_user.authored_comments.find_by_id(params[:id]) || @current_user.comments.find_by_id(params[:id])
    comment.destroy
    # Redirect
    case comment.commentable_type
    when "User"
      redirect_to :controller => "profile", :login => User.find(comment.commentable_id).login, :anchor => "comments"
    when "Group"
      redirect_to group_path(comment.commentable, :anchor => "comments")
    else
      redirect_to_main_page
    end    
  rescue
    flash[:notice] = "Couldn't delete comment!"
    redirect_to_main_page
  end
  
end
