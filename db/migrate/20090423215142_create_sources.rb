class CreateSources < ActiveRecord::Migration
  def self.up
    create_table :sources do |t|
      t.string :name
      t.string :url
      t.string :source_type
      t.boolean :enabled

      t.timestamps
    end
  end

  def self.down
    drop_table :sources
  end
end
