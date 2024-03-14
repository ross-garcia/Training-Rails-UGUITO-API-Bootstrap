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
  validates :title, :content, :note_type, presence: true
  validate :validate_content_length

  belongs_to :user
  has_one :utility, through: :user

  def word_count
    content.to_s.split.length
  end

  def content_length
    return 'short' if word_count <= utility.content_length_short
    return 'medium' if word_count <= utility.content_length_medium
    'long'
  end

  private

  def validate_content_length
    errors.add :content, validate_content_length_error if invalid_content?
  end

  def validate_content_length_error
    I18n.t('activerecord.errors.models.note.attributes.content.validate_content_length',
           limit: utility.content_length_short)
  end

  def invalid_content?
    word_count > utility.content_length_short && review?
  end
end
