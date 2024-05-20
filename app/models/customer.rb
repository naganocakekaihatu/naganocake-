class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # 現在の顧客の注文一覧を返すメソッド
  def orders
    Order.where(customer_id: self.id)
  end
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :cart_items, dependent: :destroy
  has_many :addresses, dependent: :destroy
end
