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

ActiveRecord::Schema.define(version: 20171016194701) do

  create_table "imagens", force: :cascade do |t|
    t.boolean "available"
    t.integer "propiedad_id"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "propiedads", force: :cascade do |t|
    t.string "ad_type"
    t.string "agency"
    t.boolean "available"
    t.integer "bathrooms"
    t.string "city"
    t.string "city_area"
    t.string "content"
    t.string "currency"
    t.date "date"
    t.integer "floor_area"
    t.integer "floor_number"
    t.string "id_extern"
    t.float "latitute"
    t.float "longitude"
    t.integer "parking"
    t.integer "plot_area"
    t.integer "postcode"
    t.float "price"
    t.string "property_type"
    t.string "region"
    t.integer "rooms"
    t.time "time"
    t.string "title"
    t.string "url"
    t.string "unit_floor_area"
    t.string "unit_plot_area"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
