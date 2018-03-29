FactoryBot.define do
  factory :user do
    email "hal@infinitjest.com"
    name "Hal Incandenza"
    password "password"
    api_key ENV["BATTLESHIFT_API_KEY"]
    status 0
  end
end
