# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20131126213717) do

  create_table "bloggers", force: true do |t|
    t.string   "name"
    t.string   "feed_url"
    t.integer  "semester"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.string   "twitter_handle"
  end

  create_table "entries", force: true do |t|
    t.string   "title"
    t.string   "url"
    t.string   "author"
    t.text     "summary"
    t.text     "content"
    t.datetime "published"
    t.datetime "mag_published"
    t.integer  "feed_id"
    t.boolean  "added?",        default: false
    t.string   "slug"
  end

  create_table "entries_tags", force: true do |t|
    t.integer "entry_id"
    t.integer "tag_id"
    t.boolean "visible",  default: false
  end

  create_table "feeds", force: true do |t|
    t.integer "blogger_id"
    t.string  "feed_xml"
    t.time    "last_modified"
    t.integer "etag"
  end

  create_table "subscribers", force: true do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "prospect?",  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "opt_in?",    default: true
    t.string   "hex_key"
  end

  create_table "tags", force: true do |t|
    t.string  "word"
    t.string  "slug"
    t.string  "display_word"
    t.boolean "ignore",       default: false
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.string   "password_digest"
  end

end
