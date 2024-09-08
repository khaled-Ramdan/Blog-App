class Post < ApplicationRecord
  belongs_to :user
  has_many :user
  validates :tags, presence: true
end
