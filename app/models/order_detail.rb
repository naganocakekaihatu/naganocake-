class OrderDetail < ApplicationRecord
  belongs_to :order
  belongs_to :item

  enum making_status: {impossible_manufacture: 0, waiting_manufacture: 1, manufacturing: 2, finish: 3, }
  def self.making_statuses_i18n
        making_statuses.keys.map do |status|
          [I18n.t("enums.order_detail.making_status.#{status}"), status]
        end.to_h
  end
end
