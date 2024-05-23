class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_details
  has_many :cart_items

  validates :postal_code, presence:true
  validates :address, presence:true
  validates :name, presence:true



  #支払い方法
  enum payment_method: {credit_card: 0, transfer: 1}

  #注文ステータス
  enum status: {wait_payment: 0, confirm_payment: 1, making: 2, preparing_ship: 3, finish_prepare: 4}

  def self.order_statuses_i18n
        order_statuses.keys.map do |status|
          [I18n.t("enums.order.order_status.#{status}"), status]
        end.to_h
  end

  def address_display
    '〒' + postal_code + ' ' + address + ' ' + name
  end

end
