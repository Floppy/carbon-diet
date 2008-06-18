class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.column "name", :string
      t.column "description", :string
      t.column "owner_id", :integer 
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
    end
  end

  def self.down
    drop_table :groups
  end
end
