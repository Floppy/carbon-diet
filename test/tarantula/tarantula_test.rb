require "#{File.dirname(__FILE__)}/../test_helper"
require "relevance/tarantula"

class TarantulaTestLoggedOut < ActionController::IntegrationTest
  fixtures :all

  def test_logged_out
    tarantula_crawl(self)
  end
end

class TarantulaTestLoggedInReadOnly < ActionController::IntegrationTest
  fixtures :all

  def test_logged_in_read_only
    post '/user/auth', "user[login]" => 'james', "user[password]" => 'testing'
    follow_redirect!
    t = tarantula_crawler(self)
    t.read_only = true
    t.crawl "/"
  end
end

class TarantulaTestLoggedInNonDestructive < ActionController::IntegrationTest
  fixtures :all

  def test_logged_in_non_destructive
    post '/user/auth', "user[login]" => 'james', "user[password]" => 'testing'
    follow_redirect!
    t = tarantula_crawler(self)
    t.non_destructive = true
    t.crawl "/"
  end
end

class TarantulaTestLoggedInAll < ActionController::IntegrationTest
  fixtures :all

  def test_logged_in_all
    post '/user/auth', "user[login]" => 'james', "user[password]" => 'testing'
    follow_redirect!
    tarantula_crawl(self)
  end

end