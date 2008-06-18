class EncryptedPasswords < ActiveRecord::Migration

  def self.up
    add_column :users, :password_hash, :string, :null => false, :default => ""
    add_column :users, :password_salt, :string, :null => false, :default => ""
    remove_column :users, :password
  end

  def self.down
    remove_column :users, :password_hash
    remove_column :users, :password_salt
    add_column :users, :password, :string, :null => false

  end

end
