class UserImageFlag < ActiveRecord::Migration

  def self.up
    add_column :users, :has_avatar, :boolean, :default => false, :null => false
  end
  
  def self.down
    remove_column :users, :has_avatar
  end

end
