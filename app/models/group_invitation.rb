class GroupInvitation < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  belongs_to :inviter, :class_name => "User", :foreign_key => "inviter_id"
  
  validates_presence_of :user, :group, :inviter
  
  after_create :send_notification_email
  
  def accept
    group.add_user(user)
    self.destroy
  end
  
  def reject
    self.destroy
  end
 
  def send_notification_email
    UserMailer.deliver_group_invitation(group, user) if user.confirmed_email
  end
  
end
