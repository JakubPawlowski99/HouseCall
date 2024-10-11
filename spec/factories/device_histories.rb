FactoryBot.define do
  factory :device_history do
    association :user
    association :device 
    action { :assigned }
  end
end