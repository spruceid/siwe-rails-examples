class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, id: false do |t|
      t.string :address, primary_key: true, null: false, index: { unique: true }
      t.timestamp :last_seen
      t.string :name

      t.timestamps
    end
  end
end
