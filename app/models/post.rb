class Post < ApplicationRecord
  belongs_to :user
  # has_many :user
  validates :tags, presence: true
  validates :body, presence: true
  validates :title, presence: true
end
