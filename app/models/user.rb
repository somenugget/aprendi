class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  devise :omniauthable, omniauth_providers: %i[google_oauth2 facebook twitter]

  has_many :authorizations, dependent: :destroy
  has_many :study_sets, dependent: :destroy
  has_many :folders, dependent: :destroy
  has_many :tests, dependent: :destroy
  has_many :term_progresses, dependent: :destroy
end
