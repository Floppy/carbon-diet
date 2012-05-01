require 'spec_helper'

describe "AdminMailer", ActiveSupport::TestCase do
  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures'
  CHARSET = "utf-8"

  fixtures :users

  #include ActionMailer::Quoting

  before do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @expected = TMail::Mail.new
    @expected.set_content_type "text", "plain", { "charset" => CHARSET }
    @expected.mime_version = '1.0'
  end

  it "new signup" do
    @expected.subject = 'Carbon Diet: New user signed up!'
    @expected.from    = 'info@carbondiet.org'
    @expected.to      = 'info@carbondiet.org'
    @expected.body    = read_fixture('new_signup')
    @expected.date    = Time.now
    assert_equal @expected.encoded, AdminMailer.create_new_signup("james", @expected.date).encoded
  end

  it "country request" do
    @expected.subject = 'Carbon Diet: Country request!'
    @expected.from    = 'info@carbondiet.org'
    @expected.to      = 'info@carbondiet.org'
    @expected.body    = read_fixture('country_request')
    @expected.date    = Time.now
    assert_equal @expected.encoded, AdminMailer.create_country_request(User.find(1), "United Kingdom", @expected.date).encoded
  end

  private
    def read_fixture(action)
      IO.readlines("#{FIXTURES_PATH}/admin_mailer/#{action}")
    end

    def encode(subject)
      quoted_printable(subject, CHARSET)
    end
end
