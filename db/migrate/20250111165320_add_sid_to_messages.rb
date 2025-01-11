class AddSidToMessages < ActiveRecord::Migration[8.0]
  def change
    add_column :messages, :sid, :string
  end
end
