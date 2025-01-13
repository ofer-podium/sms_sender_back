class AddChannelToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :channel, :string
  end
end
