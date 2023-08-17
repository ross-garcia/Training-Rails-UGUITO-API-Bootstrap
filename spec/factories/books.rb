FactoryBot.define do
  factory :book do
    utility
    user
    genre { Faker::Book.genre }
    author { Faker::Book.author }
    image { Faker::Avatar.image }
    title { Faker::Book.title }
    publisher { Faker::Name.name }
    year { Faker::Number.number(digits: 4) }
  end
end
