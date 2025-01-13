ActiveRecord::Schema[8.0].define(version: 2025_01_11_165320) do
  create_table "messages", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "content"
    t.string "recipient_phone"
    t.bigint "user_id", null: false
    t.datetime "sent_at"
    t.string "status", default: "sent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "sid"
    t.index ["user_id"], name: "index_messages_on_user_id"
    t.check_constraint "`status` in (_utf8mb4'sent',_utf8mb4'delivered',_utf8mb4'failed')", name: "status_check"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "username"
    t.string "hashed_password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "messages", "users"
end
