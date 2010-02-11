class UserObserver < ActiveRecord::Observer

  def after_update(user)
    user.update_stored_statistics!
  end

end