class HelpController < ApplicationController
  before_filter :get_current_user
  before_filter :check_logged_in, :only => [:country_request]
  
  def index
    @pagename = "Help"
    respond_to do |format|
      format.html
      format.iphone { render :layout => false }
    end
  end

  def about
    @pagename = "About"
  end

  def livechat
    @pagename = "Live chat"
  end

  def calculation
    @electricity_acct = @current_user.electricity_accounts.first rescue nil
    @electricity_acct = User.find(1).electricity_accounts.first if @electricity_acct.nil? or !@electricity_acct.has_enough_data_to_analyse
    @electricity_acct.electricity_supplier = ElectricitySupplier.default(@electricity_acct.user.country)
    @gas_acct = @current_user.gas_accounts.first rescue nil
    @gas_acct = User.find(1).gas_accounts.first if @gas_acct.nil? or !@gas_acct.has_enough_data_to_analyse
    @gas_acct.gas_supplier = GasSupplier.default(@gas_acct.user.country)
    @vehicle = @current_user.vehicles.first rescue nil
    @vehicle = User.find(1).vehicles.first if @vehicle.nil? or !@vehicle.has_enough_data_to_analyse
    @flight = Flight.new(:from_airport => "EGLL", :to_airport => "KLAX")
    @flight2 = Flight.new(:from_airport => "EGLL", :to_airport => "KLAX", :passengers => 2, :flight_class_id => 4)
  end

  def privacy_policy
    @pagename = "Privacy policy"
  end

  def country_request
    if request.post?
      # Send email with country request in it
      AdminMailer.deliver_country_request(@current_user, params[:country])
    end
  end

end
