FactoryBot.define do
  factory :user do
      name { "testuser" }
      email { "testuser@example.com" }
      password { "test123" }
  end
end
