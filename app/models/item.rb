class Item < ApplicationRecord
  has_one_attached :image
  belongs_to :genre
  has_many :order_details
  
  validates :genre_id, presence: true
  validates :name, presence: true
  validates :price, presence: true
  validates :introduction, presence: true
  
end
