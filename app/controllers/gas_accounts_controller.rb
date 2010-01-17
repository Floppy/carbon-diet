class GasAccountsController < BelongsToUser
  before_filter :get_account, :except => [:index, :new, :create]

  def index
    redirect_to :controller => '/data_entry/index', :action => 'edit_accounts'
  end

  def new
    @account = GasAccount.new
    # Set default values
    @account.gas_supplier = GasSupplier.default(@current_user.country)
    @account.gas_unit = @current_user.country.gas_unit
    # Get options for select
    get_select_options
  end

  def create
    @account = @user.gas_accounts.create(params[:gas_account])
    if @account.save
      @user.update_stored_statistics!
      redirect_to :controller => '/data_entry/gas', :account => @account
    else
      get_select_options
      render :action => 'new'
    end
  end

  def edit
    get_select_options
  end

  def update
    @account.update_attributes!(params[:gas_account])
    if @account.save
      @user.update_stored_statistics!
      redirect_to :controller => '/data_entry/gas', :account => @account
    else
      get_select_options
      render :action => 'edit'
    end
  end

  def destroy
    @account.destroy
    @user.update_stored_statistics!
    redirect_to :controller => '/data_entry/index', :action => 'edit_accounts'
  end

protected

  def get_select_options
    @gas_suppliers = @current_user.country.gas_suppliers.find( :all, :order => 'name')
    @gas_units = GasUnit.find( :all, :order => 'name')
  end

  def get_account
    @account = @current_user.gas_accounts.find(params[:id])
  end

end