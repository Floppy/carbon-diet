class AuthenticatedController < ApplicationController
  before_filter :check_logged_in
  
end
