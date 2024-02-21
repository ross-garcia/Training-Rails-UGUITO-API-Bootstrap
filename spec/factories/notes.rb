FactoryBot.define do
  factory :note do
    user
    title { Faker::Book.title }
    content { Faker::Lorem.sentence }
    note_type { :review }
  end
end
