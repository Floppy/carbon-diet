require 'spec_helper'

describe "UserMailer", ActiveSupport::TestCase do

  fixtures :users

  before do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    #@expected = TMail::Mail.new
    #@expected.set_content_type "text", "plain", { "charset" => CHARSET }
    #@expected.mime_version = '1.0'
  end

  it "reminder" do
    user = User.find(1)
    @expected.subject = 'A reminder from the Carbon Diet'
    @expected.from    = 'info@carbondiet.org'
    @expected.to      = user.confirmed_email
    @expected.body    = read_mail_fixture('user_mailer', 'reminder')
    @expected.date    = Time.now
    assert_equal @expected.body.encoded, UserMailer.reminder(user, @expected.date).body.encoded
  end

  it "password change" do
    # Change user password
    srand(42)
    User.find(1).reset_password
    # Send reminder email
    @expected.subject = 'Carbon Diet: Password change request'
    @expected.from    = 'info@carbondiet.org'
    @expected.to      = 'james@carbondiet.org'
    @expected.body    = read_mail_fixture('user_mailer', 'password_change')
    @expected.date    = Time.now
    assert_equal @expected.body.encoded, UserMailer.password_change(User.find(1).email, "http://www.carbondiet.org/user/change_password/" + User.find(1).password_change_code, @expected.date).body.encoded
  end

  it "email confirmation" do
    # Set email confirmation code
    user = User.find(44)
    user.email  = "james@carbondiet.org"
    user.save!
    # Prepare expected response
    @expected.subject    = 'Carbon Diet: Please confirm your email address'
    @expected.from       = 'info@carbondiet.org'
    @expected.to         = user.email
    @expected.body       = read_mail_fixture('user_mailer', 'email_confirmation')
    @expected.date       = Time.now
    assert_equal @expected.body.encoded, UserMailer.email_confirmation(user, @expected.date).body.encoded
  end
  
end
