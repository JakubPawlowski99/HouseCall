# frozen_string_literal: true

class AssignDeviceToUser
  def initialize(requesting_user:, serial_number:, new_device_owner_id:)
    @requesting_user = requesting_user
    @serial_number = serial_number
    @new_device_owner_id = new_device_owner_id
  end

  def call
    raise RegistrationError::Unauthorized if @requesting_user.id != @new_device_owner_id

    # Check if the device has already been assigned to this user before
    if Device.where(serial_number: @serial_number, user_id: @requesting_user.id).exists?
      raise AssigningError::AlreadyUsedOnUser
    end

    # Check if the user has returned this device in the past
    if ReturnedDevice.where(user: @requesting_user, device: Device.find_by(serial_number: @serial_number)).exists?
      raise AssigningError::AlreadyUsedOnUser
    end

    # Create the device for the user
    Device.create!(serial_number: @serial_number, user_id: @requesting_user.id)
  end
end