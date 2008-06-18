class Flags < ActiveRecord::Migration

  def self.up
    add_column :countries, :flag_image, :string
  end

  def self.down
    remove_column :countries, :flag_image
  end

end
