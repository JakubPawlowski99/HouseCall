# frozen_string_literal: true

class AssignDeviceToUser
  def initialize(requesting_user:, serial_number:, new_device_owner_id:)
    @requesting_user = requesting_user
    @serial_number = serial_number
    @new_device_owner_id = new_device_owner_id
  end

  def call
    raise RegistrationError::Unauthorized unless @requesting_user.id == @new_device_owner_id

    # Assuming you have a Device model
    device = Device.new(serial_number: @serial_number, user_id: @new_device_owner_id)
    
    if device.save
      return device
    else
      raise AssigningError::AlreadyUsedOnUser if device.errors.details[:user].any?
    end
  end
end