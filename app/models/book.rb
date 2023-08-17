# == Schema Information
#
# Table name: books
#
#  id         :bigint(8)        not null, primary key
#  utility_id :bigint(8)
#  user_id    :bigint(8)
#  genre      :string           not null
#  author     :string           not null
#  image      :string           not null
#  title      :string           not null
#  publisher  :string           not null
#  year       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Book < ApplicationRecord
  validates :utility_id, :user_id, :genre, :author, :image, :title, :publisher, :year,
            presence: true

  belongs_to :utility
  belongs_to :user
end
