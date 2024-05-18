class Item < ApplicationRecord
  has_one_attached :image
  belongs_to :genre
  
  validates :genre_id, presence: true
  validates :name, presence: true
  validates :price, presence: true
  validates :introduction, presence: true
  
end
