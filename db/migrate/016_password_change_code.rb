class PasswordChangeCode < ActiveRecord::Migration

  def self.up
    add_column :users, :password_change_code, :string, :default => :null
  end

  def self.down
    remove_column :users, :password_change_code
  end

end
