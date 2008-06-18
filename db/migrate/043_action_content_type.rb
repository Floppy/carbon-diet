class ActionContentType < ActiveRecord::Migration
  def self.up
    change_column :action_overrides, :content, :text, :null => false
    change_column :actions, :content, :text, :null => false
  end

  def self.down
    change_column :action_overrides, :content, :string, :null => false
    change_column :actions, :content, :string, :null => false
  end
end
