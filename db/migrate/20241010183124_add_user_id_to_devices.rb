class AddUserIdToDevices < ActiveRecord::Migration[7.1]
  def change
    add_column :devices, :user_id, :integer
  end
end
