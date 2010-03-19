require "#{File.dirname(__FILE__)}/../test_helper"
require "relevance/tarantula"

class TarantulaTest < ActionController::IntegrationTest
  fixtures :all

  def test_tarantula
    tarantula_crawl(self)
  end

  def test_tarantula_logged_in
    post '/user/auth', "user[login]" => 'james', "user[password]" => 'testing'
    follow_redirect!
    tarantula_crawl(self)
  end

end
