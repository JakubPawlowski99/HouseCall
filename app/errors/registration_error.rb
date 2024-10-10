class RegistrationError < StandardError
  class Unauthorized < RegistrationError; end
end