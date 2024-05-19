class CartItem < ApplicationRecord
  belongs_to :end_user
  belongs_to :item

  def subtotal
    item.with_tax_price * amount
  end

end
