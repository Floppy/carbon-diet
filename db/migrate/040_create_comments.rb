class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.column :user_id, :integer
      t.column :text, :text
      t.column :commentable_id, :integer, :null => false
      t.column :commentable_type, :string, :null => false
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :comments
  end
end
