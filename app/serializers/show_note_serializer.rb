class ShowNoteSerializer < ActiveModel::Serializer
  attributes :id, :title, :note_type, :word_count, :created_at, :content, :content_length
  delegate :content_length, to: :object
  delegate :word_count, to: :object

  belongs_to :user
end
