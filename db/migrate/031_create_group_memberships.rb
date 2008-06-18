class CreateGroupMemberships < ActiveRecord::Migration
  def self.up
    create_table :group_memberships do |t|
      t.column "user_id", :integer
      t.column "group_id", :integer
      t.column "created_at", :datetime
    end
  end

  def self.down
    drop_table :group_memberships
  end
end
