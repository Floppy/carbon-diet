class ElectricityAccountsController < BelongsToUser
  before_filter :get_account, :except => [:index, :new, :create]

  def index
    redirect_to :controller => '/data_entry/index', :action => 'edit_accounts'
  end

  def new
    @account = ElectricityAccount.new
    # Set default values
    @account.electricity_supplier = ElectricitySupplier.default(@current_user.country)
    @account.electricity_unit = @current_user.country.electricity_unit
    # Get options for select
    get_select_options
  end

  def create
    @account = @user.electricity_accounts.create(params[:electricity_account])
    if @account.save
      @user.update_stored_statistics!
      redirect_to user_electricity_account_electricity_readings_path(@user, @account)
    else
      get_select_options
      render :action => 'new'
    end
  end

  def edit
    get_select_options
  end

  def update
    @account.update_attributes!(params[:electricity_account])
    if @account.save
      @user.update_stored_statistics!
      redirect_to :controller => '/data_entry/electricity', :account => @account
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
    @electricity_suppliers = @current_user.country.electricity_suppliers.find( :all, :order => 'name')
    @electricity_units = ElectricityUnit.find( :all, :order => 'name')
  end

  def get_account
    @account = @current_user.electricity_accounts.find(params[:id])
  end

end