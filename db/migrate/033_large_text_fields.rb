class LargeTextFields < ActiveRecord::Migration

  def self.up
    change_column :actions, :content, :text, :null => false
    change_column :groups, :description, :text
  end

  def self.down
    change_column :groups, :description, :string
    change_column :actions, :content, :string, :null => false
  end
    
end
