class BootstrapDb < ActiveRecord::Migration
  def change
    create_table "active_admin_comments", :force => true do |t|
      t.string   "namespace"
      t.text     "body"
      t.string   "resource_id",   :null => false
      t.string   "resource_type", :null => false
      t.integer  "author_id"
      t.string   "author_type"
      t.datetime "created_at",    :null => false
      t.datetime "updated_at",    :null => false
    end

    add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
    add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
    add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_active_admin_comments_on_resource_type_and_resource_id"

    create_table "artists", :force => true do |t|
      t.string   "name"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
      t.string   "email"
      t.string   "phone"
      t.string   "slug"
    end

    add_index "artists", ["slug"], :name => "index_artists_on_slug", :unique => true

    create_table "events", :force => true do |t|
      t.string   "title"
      t.datetime "from"
      t.datetime "to"
      t.string   "registration_link"
      t.text     "description"
      t.integer  "venue_id"
      t.datetime "created_at",                            :null => false
      t.datetime "updated_at",                            :null => false
      t.integer  "seats"
      t.integer  "seat_cost"
      t.integer  "image_id"
      t.boolean  "over_21",            :default => false
      t.boolean  "private_event",      :default => false
      t.integer  "artist_id"
      t.string   "slug"
      t.integer  "duration",           :default => 120
      t.boolean  "allow_registration", :default => true
      t.boolean  "camp_session",       :default => false
    end

    add_index "events", ["slug"], :name => "index_events_on_slug", :unique => true

    create_table "friendly_id_slugs", :force => true do |t|
      t.string   "slug",                         :null => false
      t.integer  "sluggable_id",                 :null => false
      t.string   "sluggable_type", :limit => 40
      t.datetime "created_at"
    end

    add_index "friendly_id_slugs", ["slug", "sluggable_type"], :name => "index_friendly_id_slugs_on_slug_and_sluggable_type", :unique => true
    add_index "friendly_id_slugs", ["sluggable_id"], :name => "index_friendly_id_slugs_on_sluggable_id"
    add_index "friendly_id_slugs", ["sluggable_type"], :name => "index_friendly_id_slugs_on_sluggable_type"

    create_table "images", :force => true do |t|
      t.string   "image_mime_type"
      t.string   "image_name"
      t.integer  "image_size"
      t.integer  "image_width"
      t.integer  "image_height"
      t.string   "image_uid"
      t.string   "image_ext"
      t.datetime "created_at",      :null => false
      t.datetime "updated_at",      :null => false
      t.string   "slug"
    end

    add_index "images", ["slug"], :name => "index_images_on_slug", :unique => true

    create_table "living_social_codes", :force => true do |t|
      t.string   "code"
      t.string   "type"
      t.string   "bucket"
      t.string   "voucher_id"
      t.integer  "registration_id"
      t.integer  "sales_associate_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "pages", :force => true do |t|
      t.text     "body"
      t.datetime "created_at",                       :null => false
      t.datetime "updated_at",                       :null => false
      t.string   "name"
      t.boolean  "publish",       :default => false
      t.string   "meta_keywords"
      t.string   "slug"
      t.integer  "position"
    end

    add_index "pages", ["id"], :name => "index_refinery_page_parts_on_id"
    add_index "pages", ["slug"], :name => "index_pages_on_slug", :unique => true

    create_table "registrations", :force => true do |t|
      t.string   "email"
      t.integer  "event_id"
      t.string   "customer_id"
      t.string   "charge_id"
      t.integer  "quantity"
      t.text     "notes"
      t.datetime "created_at",                                                            :null => false
      t.datetime "updated_at",                                                            :null => false
      t.string   "party_name"
      t.decimal  "charged_total",        :precision => 8, :scale => 2, :default => 0.0
      t.string   "phone_number"
      t.boolean  "morning_camp",                                       :default => false
      t.boolean  "afternoon_camp",                                     :default => false
      t.boolean  "am_extended",                                        :default => false
      t.boolean  "lunch_extended_hours",                               :default => false
      t.boolean  "pm_extended_hours",                                  :default => false
    end

    create_table "roles", :force => true do |t|
      t.string "title"
    end

    create_table "roles_users", :id => false, :force => true do |t|
      t.integer "user_id"
      t.integer "role_id"
    end

    add_index "roles_users", ["role_id", "user_id"], :name => "index_refinery_roles_users_on_role_id_and_user_id"
    add_index "roles_users", ["user_id", "role_id"], :name => "index_refinery_roles_users_on_user_id_and_role_id"

    create_table "sales_associates", :force => true do |t|
      t.string   "name"
      t.string   "code"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    create_table "seo_meta", :force => true do |t|
      t.integer  "seo_meta_id"
      t.string   "seo_meta_type"
      t.string   "browser_title"
      t.string   "meta_keywords"
      t.text     "meta_description"
      t.datetime "created_at",       :null => false
      t.datetime "updated_at",       :null => false
    end

    add_index "seo_meta", ["id"], :name => "index_seo_meta_on_id"
    add_index "seo_meta", ["seo_meta_id", "seo_meta_type"], :name => "index_seo_meta_on_seo_meta_id_and_seo_meta_type"

    create_table "users", :force => true do |t|
      t.string   "username",               :null => false
      t.string   "email",                  :null => false
      t.string   "encrypted_password",     :null => false
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string   "current_sign_in_ip"
      t.string   "last_sign_in_ip"
      t.integer  "sign_in_count"
      t.datetime "remember_created_at"
      t.string   "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.datetime "created_at",             :null => false
      t.datetime "updated_at",             :null => false
    end

    add_index "users", ["id"], :name => "index_refinery_users_on_id"

    create_table "venues", :force => true do |t|
      t.string   "name"
      t.string   "address"
      t.string   "url"
      t.string   "phone"
      t.integer  "position"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
      t.boolean  "over_21"
    end
  end
end
