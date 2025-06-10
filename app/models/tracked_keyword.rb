class TrackedKeyword < ApplicationRecord
  belongs_to :user

  has_many :mentions

  validates :keyword, presence: true, format: { with: /[a-zA-Z]/, message: "must contain at least one letter" }, length: { minimum: 2 }
end
