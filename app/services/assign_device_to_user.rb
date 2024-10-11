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

    if device && device.user_id != nil
      raise AssigningError::AlreadyUsedOnOtherUser
    end

    if ReturnedDevice.where(user: @requesting_user, device: device).exists?
      raise AssigningError::AlreadyUsedOnUser
    end

    Device.create!(serial_number: @serial_number, user_id: @requesting_user.id)
  end
end