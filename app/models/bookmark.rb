class Bookmark < ApplicationRecord
  validates :url, presence: true

  scope :recent, -> { order(created_at: :desc)}
end
