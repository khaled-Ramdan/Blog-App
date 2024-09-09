class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  validates :tags, presence: true
  validates :body, presence: true
  validates :title, presence: true
end
