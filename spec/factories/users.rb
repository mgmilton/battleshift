FactoryBot.define do
  factory :user do
    email "hal@infinitjest.com"
    name "Hal Incandenza"
    password "password"
    api_key ENV["BATTLESHIFT_API_KEY"]
    status 1
    phone_number ENV["PHONE_NUMBER"]
  end

  factory :opponent, class: User do
    email "gentleman.bastard@gmail.com"
    name "Locke Lamora"
    password "password"
    api_key ENV['BATTLESHIFT_OPPONENT_API_KEY']
    status 1
    phone_number ENV["PHONE_NUMBER"]
  end

  factory :inactive_user, class: User do
    email "hal@infinitjest.com"
    name "Hal Incandenza"
    password "password"
    api_key ENV["BATTLESHIFT_API_KEY"]
    status 0
    phone_number ENV["PHONE_NUMBER"]
  end
end
