# frozen_string_literal: true

class ReturnDeviceFromUser
  def initialize(user:, serial_number:)
    @user = user
    @serial_number = serial_number
  end

  def call
    device = Device.find_by(serial_number: @serial_number, user: @user)
    raise AssigningError::DeviceNotFound if device.nil?

    device.update!(user_id: nil)

    DeviceHistory.create!(user: @user, device: device, action: 'returned')

    puts "Device returned: #{device.serial_number}, User: #{@user.id}, Action: 'returned'"
  end
end