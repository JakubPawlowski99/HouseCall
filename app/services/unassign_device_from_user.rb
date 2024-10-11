class UnassignDeviceFromUser
  def initialize(requesting_user:, serial_number:)
    @requesting_user = requesting_user
    @serial_number = serial_number
  end

  def call
    ReturnDeviceFromUser.new(user: @requesting_user, serial_number: @serial_number).call
  end
end