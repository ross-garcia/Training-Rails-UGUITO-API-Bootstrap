# == Schema Information
#
# Table name: notes
#
#  id         :bigint(8)        not null, primary key
#  user_id    :bigint(8)        not null
#  title      :string           not null
#  content    :string           not null
#  note_type  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Note < ApplicationRecord
  enum note_type: { review: 0, critique: 1 }
  validates :title, :content, :note_type, :user_id, presence: true

  belongs_to :user
  has_one :utility, through: :user
end
