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

ActiveRecord::Schema.define(version: 20160527142048) do

  create_table "auth_events", force: :cascade do |t|
    t.text     "component",  null: false
    t.text     "action",     null: false
    t.boolean  "result",     null: false
    t.text     "ip"
    t.text     "agent"
    t.integer  "user_id"
    t.datetime "timestamp",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_auth_events_on_user_id"
  end

  create_table "domain_aliases", force: :cascade do |t|
    t.text     "alias",      null: false
    t.text     "domain",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alias"], name: "index_domain_aliases_on_alias", unique: true
    t.index ["domain"], name: "index_domain_aliases_on_domain"
  end

  create_table "domains", force: :cascade do |t|
    t.text     "domain",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["domain"], name: "index_domains_on_domain", unique: true
  end

  create_table "email_aliases", force: :cascade do |t|
    t.text     "alias",      null: false
    t.text     "mail",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alias"], name: "index_email_aliases_on_alias", unique: true
  end

  create_table "emails", force: :cascade do |t|
    t.text     "mail",       null: false
    t.integer  "domain_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mail", "domain_id"], name: "index_emails_on_mail_and_domain_id", unique: true
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name",         null: false
    t.string   "display_name"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "email_id"
    t.index ["email_id"], name: "index_groups_on_email_id"
    t.index ["name"], name: "index_groups_on_name", unique: true
  end

  create_table "groups_services", id: false, force: :cascade do |t|
    t.integer "group_id",   null: false
    t.integer "service_id", null: false
    t.index ["group_id", "service_id"], name: "index_groups_services_on_group_id_and_service_id", unique: true
  end

  create_table "groups_users", id: false, force: :cascade do |t|
    t.integer "group_id", null: false
    t.integer "user_id",  null: false
    t.index ["group_id", "user_id"], name: "index_groups_users_on_group_id_and_user_id", unique: true
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "priority",   default: 0,     null: false
    t.text     "title",                      null: false
    t.text     "text",                       null: false
    t.boolean  "read",       default: false, null: false
    t.integer  "user_id"
    t.datetime "timestamp",                  null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name",         null: false
    t.string   "display_name"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "order"
    t.index ["name"], name: "index_roles_on_name", unique: true
  end

  create_table "roles_services", id: false, force: :cascade do |t|
    t.integer "service_id", null: false
    t.integer "role_id",    null: false
    t.index ["service_id", "role_id"], name: "index_roles_services_on_service_id_and_role_id", unique: true
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "role_id", null: false
    t.index ["user_id", "role_id"], name: "index_roles_users_on_user_id_and_role_id", unique: true
  end

  create_table "services", force: :cascade do |t|
    t.string   "uid",                               null: false
    t.string   "display_name",       default: "",   null: false
    t.string   "encrypted_password", default: "",   null: false
    t.integer  "sign_in_count",      default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",    default: 0,    null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.boolean  "enabled",            default: true
    t.index ["uid"], name: "index_services_on_uid", unique: true
    t.index ["unlock_token"], name: "index_services_on_unlock_token", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string   "uid",                                   null: false
    t.string   "first_name",             default: "",   null: false
    t.string   "last_name",              default: ""
    t.string   "email",                  default: "",   null: false
    t.string   "encrypted_password",     default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer  "sign_in_count",          default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",        default: 0,    null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.boolean  "enabled",                default: true
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid"], name: "index_users_on_uid", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "version_associations", force: :cascade do |t|
    t.integer "version_id"
    t.string  "foreign_key_name", null: false
    t.integer "foreign_key_id"
    t.index ["foreign_key_name", "foreign_key_id"], name: "index_version_associations_on_foreign_key"
    t.index ["version_id"], name: "index_version_associations_on_version_id"
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",                         null: false
    t.integer  "item_id",                           null: false
    t.string   "event",                             null: false
    t.string   "whodunnit"
    t.text     "object",         limit: 1073741823
    t.text     "ip"
    t.text     "user_agent"
    t.datetime "created_at"
    t.integer  "transaction_id"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
    t.index ["transaction_id"], name: "index_versions_on_transaction_id"
  end

end
