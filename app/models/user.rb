class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # has_one :promotion, foreign_key: :created_by
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :email, format: { with: /\A([^@\s]+)@locaweb\.com\.br\z/i, on: :create }
end
