class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.string :content
      t.string :recipient_phone
      t.references :user, null: false, foreign_key: true
      t.datetime :sent_at
      t.string :status, default: 'sent' 
      
      t.timestamps
    end
    add_check_constraint :messages, "status IN ('sent', 'delivered', 'failed')", name: "status_check"

  end
end
