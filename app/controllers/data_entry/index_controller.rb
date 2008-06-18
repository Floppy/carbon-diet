class DataEntry::IndexController < AuthenticatedController

  def index
    if @current_user.has_no_accounts
      redirect_to :action => 'new_account'
      return
    end
    @pagename = "Add data"
  end

  def new_account
    @pagename = "Add account"
  end

  def edit_accounts
    if @current_user.has_no_accounts
      redirect_to :action => 'new_account'
      return
    end
    @pagename = "Edit accounts"
  end

end
