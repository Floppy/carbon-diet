class UserMailer < ActionMailer::Base

  def reminder(email, sent_at = Time.now)
    setup(sent_at)
    @subject     = 'A reminder from the Carbon Diet'
    @recipients  = email
  end

  def password_change(email, url, sent_at = Time.now)
    setup(sent_at)
    @subject        = 'Carbon Diet: Password change request'
    @body["url"]    = url
    @recipients     = email
  end

  def group_invitation(group, user, sent_at = Time.now)
    setup(sent_at)
    @subject       = 'Carbon Diet: Group invitation'
    @body["group"] = group
    @recipients    = user.email
  end

  def friend_request(name, email, sent_at = Time.now)
    setup(sent_at)
    @subject     = 'Carbon Diet: Friend request'
    @body["name"] = name
    @recipients  = email
  end

  def comment_notification(user, commenter, sent_at = Time.now)
    setup(sent_at)
    @subject      = 'Carbon Diet: Someone wrote a comment on your profile!'
    @body["from"] = commenter.name
    @recipients   = user.email
  end

  def email_confirmation(user, sent_at = Time.now)
    setup(sent_at)
    @subject      = 'Carbon Diet: Please confirm your email address'
    @body["code"] = user.confirmation_code
    @recipients   = user.email
  end

  def friend_invitation(from, email, group, sent_at = Time.now)
    setup(sent_at)
    @subject       = 'An invitation to join The Carbon Diet'
    @body["from"]  = from
    @body["group"] = group
    @recipients    = email
  end

private

  def setup(sent_at)   
    @from            = 'Carbon Diet <info@carbondiet.org>'
    @sent_on         = sent_at
    @headers         = {}
  end

end
