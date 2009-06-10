# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090516205122) do

  create_table "filters", :force => true do |t|
    t.integer  "source_id"
    t.string   "keyword"
    t.boolean  "positive",   :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", :force => true do |t|
    t.string   "host"
    t.integer  "port"
    t.string   "user"
    t.string   "password"
    t.string   "path"
    t.integer  "session_uplimit"
    t.integer  "session_downlimit"
    t.float    "ratio"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sources", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "source_type"
    t.boolean  "enabled"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "torrents", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "torrent_url"
    t.string   "torrent_data"
    t.integer  "transmission_id"
    t.integer  "transmission_total_size"
    t.integer  "transmission_name"
    t.integer  "transmission_downloaded_size"
    t.integer  "transmission_upload_ratio"
    t.integer  "transmission_status"
    t.integer  "transmission_hash_string"
    t.string   "imdb_url"
    t.integer  "state",                        :default => 0
    t.float    "ratio",                        :default => 1.0
    t.integer  "uplimit"
    t.integer  "downlimit"
    t.integer  "source_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
