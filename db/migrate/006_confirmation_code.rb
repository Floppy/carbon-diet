class ConfirmationCode < ActiveRecord::Migration

  def self.up
    add_column :users, :confirmation_code, :string
  end

  def self.down
    remove_column :users, :confirmation_code
  end

end
