module Public
  class OrdersController < ApplicationController
    # before_action :authenticate_customer!
    def new
    end
  
    def confirm
    end
  
    def thanks
    end
  
    def creat
    end
  
    def index
      @orders = current_customer.orders
    end
  
    def show
      # orderの特定
      @order = Order.find(params[:id])
      @order_item = @order.order_items
      # 計算
      @total = 0
    end
  end
end