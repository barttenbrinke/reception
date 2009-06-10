class CreateFilters < ActiveRecord::Migration
  def self.up
    create_table :filters do |t|
      t.integer :source_id
      t.string :keyword
      t.boolean :positive, :default => true

      t.timestamps
    end
  end

  def self.down
    drop_table :filters
  end
end
