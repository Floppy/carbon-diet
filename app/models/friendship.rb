class Friendship < ActiveRecord::Base
  belongs_to :user, :foreign_key => "user_id", :class_name => "User"
  belongs_to :friend, :foreign_key => "friend_id", :class_name => "User"

  def approve
    self.approved = true
    self.save
  end
  
  def reject
    self.destroy
  end

end
