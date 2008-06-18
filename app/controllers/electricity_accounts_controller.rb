class ElectricityAccountsController < AuthenticatedController
  def index
    redirect_to :controller => '/data_entry/index', :action => 'edit_accounts'
  end

  def edit
    @electricity_account = params[:id] ? @current_user.electricity_accounts.find_by_id(params[:id]) : ElectricityAccount.new
    @electricity_suppliers = @current_user.country.electricity_suppliers.find( :all, :order => 'name')
    @electricity_units = ElectricityUnit.find( :all, :order => 'name')
    unless request.post? or params[:id]
      @electricity_account.electricity_supplier = ElectricitySupplier.default(@current_user.country)
      @electricity_account.electricity_unit = @current_user.country.electricity_unit
    end
    if request.post?
      @electricity_account.user = @current_user
      @electricity_account.update_attributes(params[:electricity_account])
      @current_user.update_stored_statistics!
      redirect_to :controller => '/data_entry/electricity', :account => @electricity_account  if @electricity_account.save
    end
    # Set page name
    if params[:id]
      @pagename = "Editing " + @electricity_account.name
    else
      @pagename = "Add electricity account"
    end
  end

  def destroy
    account = @current_user.electricity_accounts.find_by_id(params[:id])
    account.destroy if not account.nil?
    @current_user.update_stored_statistics!
    index
  end

end
