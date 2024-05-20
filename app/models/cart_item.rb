class CartItem < ApplicationRecord
  belongs_to :end_user
  belongs_to :item
  belongs_to :order, optional: true

  def subtotal
    item.with_tax_price * amount
  end

end
