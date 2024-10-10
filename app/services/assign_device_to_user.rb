# frozen_string_literal: true

class AssignDeviceToUser
  def initialize(requesting_user:, serial_number:, new_device_owner_id:)
    @requesting_user = requesting_user
    @serial_number = serial_number
    @new_device_owner_id = new_device_owner_id
  end

  def call
    if @requesting_user.id != @new_device_owner_id
      raise RegistrationError::Unauthorized
    end

    if Device.where(serial_number: @serial_number, user_id: @requesting_user.id).exists?
      raise AssigningError::AlreadyUsedOnUser
    end
    Device.create!(serial_number: @serial_number, user_id: @requesting_user.id)
  end
end