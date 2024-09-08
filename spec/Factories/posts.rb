FactoryBot.define do
  factory :post do
    title { "MyString" }
    body { "MyText" }
    user { nil }
    tags { "MyString" }
  end
end
