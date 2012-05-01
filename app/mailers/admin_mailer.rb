class AdminMailer < ActionMailer::Base

  def new_signup(name, sent_at = Time.now)
    setup(sent_at)
    @subject     = 'Carbon Diet: New user signed up!'
    @body["name"] = name
  end

  def country_request(user, country, sent_at = Time.now)
    setup(sent_at)
    @subject         = 'Carbon Diet: Country request!'
    @body["login"]   = user.login
    @body["country"] = country
  end

private
  
  def setup(sent_at)   
    @recipients      = 'info@carbondiet.org'
    @from            = 'info@carbondiet.org'
    @sent_on         = sent_at
    @headers         = {}
  end

end
