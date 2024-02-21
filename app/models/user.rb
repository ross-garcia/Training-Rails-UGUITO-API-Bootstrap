# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  first_name             :string           default("")
#  last_name              :string           default("")
#  document_number        :string           default("")
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  utility_id             :bigint(8)
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  self.skip_session_storage = %i[http_auth params_auth]

  belongs_to :utility
  has_many :books, dependent: :destroy
  has_many :notes, dependent: :destroy
end
