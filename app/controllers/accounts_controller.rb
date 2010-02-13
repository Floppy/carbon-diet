class AccountsController < BelongsToUser

  def show
    redirect_to new_user_accounts_path(@user) and return if @user.has_no_accounts
  end

  def new
  end

  def edit
    redirect_to new_user_accounts_path(@user) and return if @user.has_no_accounts
  end

end
