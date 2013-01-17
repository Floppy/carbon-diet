Given /^I am using Mobile Safari$/ do
  # Force this with a monkeypatch - is this evil? I suspect so...
  class ApplicationController < ActionController::Base
    def iphone?
      true
    end
  end
end

Given /^I am logged in as "([^\"]*)" with password "([^\"]*)"$/ do |username, password|
  visit '/'
  fill_in "user[login]", :with => username
  fill_in "user[password]", :with => password
  click_link "Log In"
end