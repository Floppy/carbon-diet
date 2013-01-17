class AdminMailer < ActionMailer::Base

  default :from => 'info@carbondiet.org',
          :to   => 'info@carbondiet.org'

  def new_signup(name, sent_at = Time.now)
    @name = name
    mail :date => sent_at, :subject => 'Carbon Diet: New user signed up!'
  end

  def country_request(user, country, sent_at = Time.now)
    @login   = user.login
    @country = country
    mail :date => sent_at, :subject => 'Carbon Diet: Country request!'
  end

end
