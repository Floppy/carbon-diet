Given /^I am using Mobile Safari$/ do
  # Force this with a monkeypatch - is this evil? I suspect so...
  class ApplicationController < ActionController::Base
    def iphone?
      true
    end
  end
end