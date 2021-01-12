class Post < ApplicationRecord
  belongs_to :user
  has_many :links, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :pickups, dependent: :destroy
end
