class CreateCompletedActions < ActiveRecord::Migration

  def self.up
    create_table :completed_actions do |t|
      t.column "user_id", :integer, :limit => 10, :default => 0, :null => false
      t.column "action_id", :integer, :limit => 10, :default => 0, :null => false
      t.column "done", :boolean
      t.column "created_on", :date
    end
    add_column :actions, :level, :integer, :limit => 10, :default => 1, :null => false
  end

  def self.down
    drop_table :completed_actions
    remove_column :actions, :level
  end
end
