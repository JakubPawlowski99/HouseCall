# frozen_string_literal: true

class AssignDeviceToUser
  def initialize(requesting_user:, serial_number:, new_device_owner_id:)
    @requesting_user = requesting_user
    @serial_number = serial_number
    @new_device_owner_id = new_device_owner_id
  end

  def call
    raise RegistrationError::Unauthorized if @requesting_user.id != @new_device_owner_id

    device = Device.find_or_create_by(serial_number: @serial_number)
    previous_assignment = DeviceHistory.where(user: @requesting_user, device: device, action: 'assigned').exists?
    previous_return = DeviceHistory.where(user: @requesting_user, device: device, action: 'returned').exists?

    if previous_assignment && !previous_return
      puts "User has previously assigned this device and hasn't returned it: #{device.serial_number}, blocking re-registration"
      raise AssigningError::AlreadyUsedOnUser
    end

    if device.user_id.present? && device.user_id != @requesting_user.id
      puts "Device is currently assigned to another user: #{device.user_id}"
      raise AssigningError::AlreadyUsedOnOtherUser
    end

    # Assign device to user
    device.update!(user: @requesting_user)

    # Log the assignment in history
    DeviceHistory.create!(user: @requesting_user, device: device, action: 'assigned')
    puts "Device assigned to user #{device.user_id}"
  end
end