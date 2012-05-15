class ElectricityAccountsController < BelongsToUser
  before_filter :get_account, :except => [:new, :create]
  before_filter :get_select_options, :except => [:destroy]

  def new
    @account = ElectricityAccount.new
    # Set default values
    @account.electricity_supplier = ElectricitySupplier.default(@current_user.country)
    @account.electricity_unit = @current_user.country.electricity_unit
  end

  def create
    @account = @user.electricity_accounts.create(params[:electricity_account])
    if @account.save
      redirect_to user_electricity_account_readings_path(@user, @account)
    else
      render :action => 'new'
    end
  end

  def edit
  end

  def update
    @account.update_attributes!(params[:electricity_account])
    if @account.save
      redirect_to user_electricity_account_readings_path(@user, @account)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @account.destroy
    redirect_to user_accounts_path(@user)
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