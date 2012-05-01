class UserMailer < ActionMailer::Base

  def reminder(user, sent_at = Time.now)
    setup('A reminder from the Carbon Diet', user.confirmed_email, sent_at)
    body :user => user
  end

  def password_change(email, url, sent_at = Time.now)
    setup('Carbon Diet: Password change request', email, sent_at)
    body :url => url
  end

  def group_invitation(group, user, sent_at = Time.now)
    setup('Carbon Diet: Group invitation', user.email, sent_at)
    body :group => group, :user => user
  end

  def friend_request(user, friend, sent_at = Time.now)
    setup('Carbon Diet: Friend request', friend.confirmed_email, sent_at)
    body :user => user, :friend => friend
  end

  def comment_notification(user, commenter, sent_at = Time.now)
    setup('Carbon Diet: Someone wrote a comment on your profile!', user.email, sent_at)
    body :commenter => commenter.name
  end

  def email_confirmation(user, sent_at = Time.now)
    setup('Carbon Diet: Please confirm your email address', user.email, sent_at)
    body :code => user.confirmation_code
  end

  def friend_invitation(from, email, group, sent_at = Time.now)
    setup('An invitation to join The Carbon Diet', email, sent_at)
    body :sender => from, :group => group
  end

private

  def setup(subj, email, sent_at)
    subject subj
    recipients email
    from 'info@carbondiet.org'
    sent_on sent_at
  end

end
