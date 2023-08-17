class ShowBookSerializer < ActiveModel::Serializer
  attributes :id, :title, :author, :genre, :image, :publisher, :year
  belongs_to :user, serializer: UserSerializer
end
