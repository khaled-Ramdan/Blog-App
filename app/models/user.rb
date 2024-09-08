class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true, minimum: 3
  validates :password, presence: true, minimum: 3
  has_many :posts, dependent: :destroy # User have many posts. If the user is deleted, all of his posts will be deleted also.
  has_many :comments
end
