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
      raise AssigningError::AlreadyUsedOnUser
    end

    if device.user_id.present? && device.user_id != @requesting_user.id
      raise AssigningError::AlreadyUsedOnOtherUser
    end

    device.update!(user: @requesting_user)

    DeviceHistory.create!(user: @requesting_user, device: device, action: 'assigned')
  end
end