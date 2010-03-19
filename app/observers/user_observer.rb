class UserObserver < ActiveRecord::Observer

  def before_update(user)
    user.update_stored_statistics!(false)
  end

end