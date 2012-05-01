class UserMailer < ActionMailer::Base
  default :from => 'info@carbondiet.org'

  def reminder(user, sent_at = Time.now)
    @user = user
    mail  :subject => 'A reminder from the Carbon Diet', 
          :to => user.confirmed_email, 
          :sent_on => sent_at
  end

  def password_change(email, url, sent_at = Time.now)
    @url = url
    mail  :subject => 'Carbon Diet: Password change request', 
          :to => email, 
          :sent_on => sent_at
  end

  def group_invitation(group, user, sent_at = Time.now)
    @group = group
    @user = user
    mail  :subject => 'Carbon Diet: Group invitation', 
          :to => user.email, 
          :sent_on => sent_at
  end

  def friend_request(user, friend, sent_at = Time.now)
    @friend = friend
    @user = user
    mail  :subject => 'Carbon Diet: Friend request', 
          :to => friend.confirmed_email, 
          :sent_on => sent_at
  end

  def comment_notification(user, commenter, sent_at = Time.now)
    @commenter = commenter.name
    mail  :subject => 'Carbon Diet: Someone wrote a comment on your profile!', 
          :to => user.email, 
          :sent_on => sent_at
  end

  def email_confirmation(user, sent_at = Time.now)
    @code = user.confirmation_code
    mail  :subject => 'Carbon Diet: Please confirm your email address', 
          :to => user.email, 
          :sent_on => sent_at
  end

  def friend_invitation(from, email, group, sent_at = Time.now)
    @sender = from
    @group = group
    mail  :subject => 'An invitation to join The Carbon Diet', 
          :to => email, 
          :sent_on => sent_at
  end

end
