# frozen_string_literal: true

class AssignDeviceToUser
  def initialize(requesting_user:, serial_number:, new_device_owner_id:)
    @requesting_user = requesting_user
    @serial_number = serial_number
    @new_device_owner_id = new_device_owner_id
  end

  def call
    raise RegistrationError::Unauthorized if @requesting_user.id != @new_device_owner_id

    device = Device.find_by(serial_number: @serial_number)
    raise AssigningError::DeviceNotFound if device.nil?

    if DeviceHistory.where(user: @requesting_user, device: device, action: 'returned').exists?
      raise AssigningError::AlreadyUsedOnUser
    end

    if device.user_id.present? && device.user_id != @requesting_user.id
      raise AssigningError::AlreadyUsedOnOtherUser
    end

    device.update!(user: @requesting_user)

    DeviceHistory.create!(user: @requesting_user, device: device, action: 'assigned')
  end
end