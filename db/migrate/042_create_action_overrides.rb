class CreateActionOverrides < ActiveRecord::Migration
  def self.up
    # Remove defunct action columns
    remove_column :actions, :country_id
    # Create override table
    create_table :action_overrides do |t|
      t.column :action_id, :integer
      t.column :content, :string, :null => false
      t.column :paid_for, :boolean, :null => false, :default => false
      t.column :country_id, :integer, :null => false, :default => 0
    end
  end

  def self.down
    # Remove override table
    drop_table :action_overrides
    # Restore defunct action columns
    add_column :actions, :country_id, :integer, :limit => 10, :null => true
  end
end
