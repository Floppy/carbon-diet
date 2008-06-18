class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.column :note, :text, :null => false
      t.column :date, :date
      t.column :notatable_id, :integer
      t.column :notatable_type, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :notes
  end
end
