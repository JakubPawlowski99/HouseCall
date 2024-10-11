class DeviceHistory < ApplicationRecord
  belongs_to :user
  belongs_to :device

  enum action: { assigned: 0, returned: 1 }

  validates :user_id, presence: true
  validates :device_id, presence: true
  validates :action, presence: true
end