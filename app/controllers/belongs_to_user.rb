class BelongsToUser < AuthenticatedController
  before_filter :get_user

protected

  def get_user
    @user = User.find_by_login(params[:user_id])
    render_http_code(404) if @user.nil?
    render_http_code(401) unless @user == @current_user || (@current_user && @current_user.admin)
  end

end
