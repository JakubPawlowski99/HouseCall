class CreateDeviceHistories < ActiveRecord::Migration[7.1]
  def change
    create_table :device_histories do |t|
      t.references :user, null: false, foreign_key: true
      t.references :device, null: false, foreign_key: true
      t.integer :action

      t.timestamps
    end
  end
end
