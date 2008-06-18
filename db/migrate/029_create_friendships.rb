class CreateFriendships < ActiveRecord::Migration
  def self.up
    create_table :friendships do |t|
      t.column "user_id", :integer
      t.column "friend_id", :integer
      t.column "approved", :boolean, :default => false, :null => false
      t.column "created_at", :datetime
    end
  end

  def self.down
    drop_table :friendships
  end
end
