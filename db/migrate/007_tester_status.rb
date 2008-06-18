class TesterStatus < ActiveRecord::Migration

  def self.up
    add_column :users, :tester, :boolean
  end

  def self.down
    remove_column :users, :tester
  end

end
