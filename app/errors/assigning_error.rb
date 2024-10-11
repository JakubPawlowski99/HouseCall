class AssigningError < StandardError; end

class AssigningError::AlreadyUsedOnUser < AssigningError; end
class AssigningError::AlreadyUsedOnOtherUser < AssigningError; end
class AssigningError::DeviceNotFound < AssigningError; end