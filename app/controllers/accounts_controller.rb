class AccountsController < BelongsToUser

  def show
    redirect_to new_user_accounts_path(@user) and return if @user.has_no_accounts
    @pagename = "Add data"
  end

  def new
    @pagename = "Add account"
  end

  def edit
    redirect_to new_user_accounts_path(@user) and return if @user.has_no_accounts
    @pagename = "Edit accounts"
  end

end
