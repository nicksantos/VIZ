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

ActiveRecord::Schema.define(:version => 20091204052652) do

  create_table "flights", :force => true do |t|
    t.string   "import_id"
    t.string   "title"
    t.integer  "time"
    t.float    "latitude"
    t.float    "longitude"
    t.float    "altitude"
    t.float    "groundspeed"
    t.float    "heading"
    t.float    "air_temp"
    t.float    "air_density"
    t.float    "pressure"
    t.string   "point_source"
    t.float    "altDot"
    t.float    "delta_distance"
    t.float    "windDir"
    t.float    "windMag"
    t.float    "true_airspeedCalc"
    t.float    "true_airspeedUsed"
    t.float    "true_airspeed"
    t.float    "true_airspeed_dot"
    t.float    "bank_angle"
    t.string   "config"
    t.float    "lift_coeff"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

