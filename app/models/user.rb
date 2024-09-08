class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  has_many :posts, dependent: :destroy # User have many posts. If the user is deleted, all of his posts will be deleted also.
  has_many :comments
end
