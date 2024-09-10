FactoryBot.define do
  factory :post do
    title { "test post title" }
    body { "test post body" }
    tags { [ "tag1", "tag2" ] }
  end
end
