class GasAccountsController < AuthenticatedController
  def index
    redirect_to :controller => '/data_entry/index', :action => 'edit_accounts'
  end

  def edit
    @gas_account = params[:id] ? @current_user.gas_accounts.find_by_id(params[:id]) : GasAccount.new
    @gas_suppliers = @current_user.country.gas_suppliers.find( :all, :order => 'name')
    @gas_units = GasUnit.find( :all, :order => 'name')
    unless request.post? or params[:id]
      @gas_account.gas_supplier = GasSupplier.default(@current_user.country)
      @gas_account.gas_unit = @current_user.country.gas_unit
    end
    if request.post?
      @gas_account.user = @current_user
      @gas_account.update_attributes(params[:gas_account])
      @current_user.update_stored_statistics!
      redirect_to :controller => '/data_entry/gas', :account => @gas_account if @gas_account.save
    end
    # Set page name
    if params[:id]
      @pagename = "Editing " + @gas_account.name
    else
      @pagename = "Add gas account"
    end
  end

  def destroy
    account = @current_user.gas_accounts.find_by_id(params[:id])
    account.destroy if not account.nil?
    @current_user.update_stored_statistics!
    index
  end

end
