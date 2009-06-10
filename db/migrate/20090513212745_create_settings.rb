class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.string :host
      t.integer :port
      t.string :user
      t.string :password
      t.string :path
      t.integer :session_uplimit
      t.integer :session_downlimit
      t.float :ratio

      t.timestamps
    end
  end

  def self.down
    drop_table :settings
  end
end
