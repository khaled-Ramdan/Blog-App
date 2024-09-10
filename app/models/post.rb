class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  validate :tags_must_be_present
  validates :body, presence: true
  validates :title, presence: true

  private
  def tags_must_be_present
    if tags.blank? || tags.length.zero?
      errors.add(:tags, "must have at least one tag")
    end
  end
end
