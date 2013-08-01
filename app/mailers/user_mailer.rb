class UserMailer < ActionMailer::Base
  default :from => 'info@carbondiet.org'

  def reminder(user, sent_at = Time.now)
    @user = user
    mail  :subject => 'A reminder from the Carbon Diet', 
          :to => user.confirmed_email, 
          :date => sent_at
  end

  def password_change(email, url, sent_at = Time.now)
    @url = url
    mail  :subject => 'Carbon Diet: Password change request', 
          :to => email, 
          :date => sent_at
  end

  def email_confirmation(user, sent_at = Time.now)
    @code = user.confirmation_code
    mail  :subject => 'Carbon Diet: Please confirm your email address', 
          :to => user.email, 
          :date => sent_at
  end

end
