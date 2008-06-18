class CreateGroupInvitations < ActiveRecord::Migration
  def self.up
    create_table :group_invitations do |t|
      t.column :user_id, :integer
      t.column :group_id, :integer
      t.column :inviter_id, :integer
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :group_invitations
  end
end
