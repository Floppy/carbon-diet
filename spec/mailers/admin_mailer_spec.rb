require 'spec_helper'

describe "AdminMailer", ActiveSupport::TestCase do

  fixtures :users

  before do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    #@expected = TMail::Mail.new
    #@expected.set_content_type "text", "plain", { "charset" => CHARSET }
    #@expected.mime_version = '1.0'
  end

  it "new signup" do
    @expected.subject = 'Carbon Diet: New user signed up!'
    @expected.from    = 'info@carbondiet.org'
    @expected.to      = 'info@carbondiet.org'
    @expected.body    = read_mail_fixture('admin_mailer', 'new_signup')
    @expected.date    = Time.now
    assert_equal @expected.body.encoded, AdminMailer.new_signup("james", @expected.date).body.encoded
  end

  it "country request" do
    @expected.subject = 'Carbon Diet: Country request!'
    @expected.from    = 'info@carbondiet.org'
    @expected.to      = 'info@carbondiet.org'
    @expected.body    = read_mail_fixture('admin_mailer', 'country_request')
    @expected.date    = Time.now
    assert_equal @expected.body.encoded, AdminMailer.country_request(User.find(1), "United Kingdom", @expected.date).body.encoded
  end

end
