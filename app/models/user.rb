class User < ApplicationRecord
  has_secure_password
  has_one_attached :image
  validates :email, presence: true, uniqueness: true, length: { minimum: 3, message: "Must be at least 3 characters" }
  validates :password, presence: true, length: { minimum: 3, message: "Must be at least 3 characters" }
  has_many :posts, dependent: :destroy # User have many posts. If the user is deleted, all of his posts will be deleted also.
  has_many :comments
end
