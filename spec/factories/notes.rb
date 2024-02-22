FactoryBot.define do
  factory :note do
    user
    title { Faker::Book.title }
    content { Faker::Lorem.sentence }
    note_type { Note.note_types.values.sample }
  end
end
