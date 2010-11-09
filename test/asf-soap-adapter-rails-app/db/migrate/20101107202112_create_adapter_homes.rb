class CreateAdapterHomes < ActiveRecord::Migration
  def self.up
    create_table :adapter_homes do |t|
      t.string :name
      t.string :description
      t.string :version

      t.timestamps
    end
  end

  def self.down
    drop_table :adapter_homes
  end
end
