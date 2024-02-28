class NoteSerializer < ActiveModel::Serializer
  attributes :id, :title, :note_type, :content_length
  delegate :content_length, to: :object
end
