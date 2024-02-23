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

  def word_count
    content.split.length
  end

  def content_length_of_north_utility
    case word_count
    when 0..50
      'short'
    when 51..100
      'medium'
    else
      'long'
    end
  end

  def content_length_of_south_utility
    case word_count
    when 0..60
      'short'
    when 61..120
      'medium'
    else
      'long'
    end
  end

  def content_length
    case utility.type
    when 'SouthUtility'
      content_lenght_of_south_utility
    when 'NorthUtility'
      content_lenght_of_north_utility
    end
  end
end
