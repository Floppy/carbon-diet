class CreateActions < ActiveRecord::Migration
  def self.up

    create_table :action_categories do |t|
      t.column :name, :string, :null => false
      t.column :image, :string, :null => false
    end
    ActionCategory.create(:name => "Electricity", :image => 'electricity')
    ActionCategory.create(:name => "Heating", :image => 'gas' )
    ActionCategory.create(:name => "Hot Water", :image => 'gas')
    ActionCategory.create(:name => "Travel", :image => 'car' )

    create_table :actions do |t|
      t.column :title, :string, :null => false
      t.column :content, :string, :null => false
      t.column :image, :string, :null => true
      t.column :country_id, :integer, :limit => 10, :null => true
      t.column :action_category_id, :integer, :limit => 10, :default => 1, :null => false
    end

  end

  def self.down
    drop_table :actions
    drop_table :action_categories
  end
end
