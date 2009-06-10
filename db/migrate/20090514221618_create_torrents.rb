class CreateTorrents < ActiveRecord::Migration
  def self.up
    create_table :torrents do |t|
      t.string :name
      t.string :description
      t.string :torrent_url
      t.string :torrent_data
      t.integer :transmission_id
      t.integer :transmission_total_size
      t.integer :transmission_name
      t.integer :transmission_downloaded_size
      t.integer :transmission_upload_ratio
      t.integer :transmission_status
      t.integer :transmission_hash_string
      t.string :imdb_url
      t.integer :state, :default => 0
      t.float :ratio, :default => 1.0
      t.integer :uplimit
      t.integer :downlimit
      t.integer :source_id

      t.timestamps
    end
  end

  def self.down
    drop_table :torrents
  end
end
