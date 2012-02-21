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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110120093948) do

  create_table "merchants", :force => true do |t|
    t.string   "email"
    t.string   "login_id"
    t.string   "customer_id"
    t.string   "business_name"
    t.string   "business_phone"
    t.integer  "business_type"
    t.string   "contact_name"
    t.string   "contact_email"
    t.boolean  "tc_accepted"
    t.boolean  "is_active"
    t.datetime "create_at"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  create_table "subscriptions", :force => true do |t|
    t.string   "status"
    t.string   "plan_id"
    t.string   "sub_id"
    t.string   "cc_token"
    t.string   "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
