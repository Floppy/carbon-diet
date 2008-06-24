require File.dirname(__FILE__) + '/../test_helper'

class UserMailerTest < Test::Unit::TestCase
  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures'
  CHARSET = "utf-8"

  fixtures :users
  fixtures :groups

  include ActionMailer::Quoting

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @expected = TMail::Mail.new
    @expected.set_content_type "text", "plain", { "charset" => CHARSET }
    @expected.mime_version = '1.0'
  end

  def test_reminder
    @expected.subject = 'A reminder from the Carbon Diet'
    @expected.from    = 'Carbon Diet <info@carbondiet.org>'
    @expected.to      = 'james@carbondiet.org'
    @expected.body    = read_fixture('reminder')
    @expected.date    = Time.now
    assert_equal @expected.encoded, UserMailer.create_reminder(@expected.to, @expected.date).encoded
  end

  def test_password_change
    # Change user password
    srand(42)
    User.find(1).reset_password
    # Send reminder email
    @expected.subject = 'Carbon Diet: Password change request'
    @expected.from    = 'Carbon Diet <info@carbondiet.org>'
    @expected.to      = 'james@carbondiet.org'
    @expected.body    = read_fixture('password_change')
    @expected.date    = Time.now
    assert_equal @expected.encoded, UserMailer.create_password_change(User.find(1).email, "http://www.carbondiet.org/user/change_password/" + User.find(1).password_change_code, @expected.date).encoded
  end

  def test_group_invitation
    @expected.subject = 'Carbon Diet: Group invitation'
    @expected.from    = 'Carbon Diet <info@carbondiet.org>'
    @expected.to      = 'james@carbondiet.org'
    @expected.body    = read_fixture('group_invitation')
    @expected.date    = Time.now
    assert_equal @expected.encoded, UserMailer.create_group_invitation(Group.find(1), User.find(1), @expected.date).encoded
  end

  def test_friend_request
    @expected.subject = 'Carbon Diet: Friend request'
    @expected.from    = 'Carbon Diet <info@carbondiet.org>'
    @expected.to      = 'james@carbondiet.org'
    @expected.body    = read_fixture('friend_request')
    @expected.date    = Time.now
    assert_equal @expected.encoded, UserMailer.create_friend_request("Test002", @expected.to, @expected.date).encoded
  end

  def test_comment_notification
    @expected.subject    = 'Carbon Diet: Someone wrote a comment on your profile!'
    @expected.from       = 'Carbon Diet <info@carbondiet.org>'
    @expected.to         = 'james@carbondiet.org'
    @expected.body       = read_fixture('comment_notification')
    @expected.date       = Time.now
    assert_equal @expected.encoded, UserMailer.create_comment_notification(User.find(1), User.find(2), @expected.date).encoded
  end

  def test_email_confirmation
    # Set email confirmation code
    user = User.find(44)
    user.email  = "james@carbondiet.org"
    user.save!
    # Prepare expected response
    @expected.subject    = 'Carbon Diet: Please confirm your email address'
    @expected.from       = 'Carbon Diet <info@carbondiet.org>'
    @expected.to         = user.email
    @expected.body       = read_fixture('email_confirmation')
    @expected.date       = Time.now
    assert_equal @expected.encoded, UserMailer.create_email_confirmation(user, @expected.date).encoded
  end

  def test_friend_invitation
    @expected.subject    = 'An invitation to join The Carbon Diet'
    @expected.from       = 'Carbon Diet <info@carbondiet.org>'
    @expected.to         = 'james@carbondiet.org'
    @expected.body       = read_fixture('friend_invitation')
    @expected.date       = Time.now
    assert_equal @expected.encoded, UserMailer.create_friend_invitation(User.find(1), "james@carbondiet.org", "0", @expected.date).encoded
  end

  def test_friend_invitation_with_group
    @expected.subject    = 'An invitation to join The Carbon Diet'
    @expected.from       = 'Carbon Diet <info@carbondiet.org>'
    @expected.to         = 'james@carbondiet.org'
    @expected.body       = read_fixture('friend_invitation_with_group')
    @expected.date       = Time.now
    assert_equal @expected.encoded, UserMailer.create_friend_invitation(User.find(1), "james@carbondiet.org", "2", @expected.date).encoded
  end

  private
    def read_fixture(action)
      IO.readlines("#{FIXTURES_PATH}/user_mailer/#{action}")
    end

    def encode(subject)
      quoted_printable(subject, CHARSET)
    end
end
