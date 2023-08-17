class IndexBookSerializer < ActiveModel::Serializer
  attributes :id, :title, :author, :genre
end
