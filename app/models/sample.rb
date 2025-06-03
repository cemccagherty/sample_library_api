class Sample < ApplicationRecord
  belongs_to :user
  has_one_attached :audio

  validates :name, presence: true, length: { maximum: 24 }
end
