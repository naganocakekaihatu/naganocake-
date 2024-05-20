module Public
  class OrdersController < ApplicationController
    # before_action :authenticate_customer!
    def new
      @order = Order.new
    end
  
    def confirm
      @order = Order.new(order_params)
      if @order.valid?
        case @order.number
        when 1
          # 「自身の住所」が選択された場合の処理
          # 顧客の住所情報を取得し、表示するか別の処理を行う
          @address = current_customer.address
        when 2
          # 「登録済み住所」が選択された場合の処理
          # 顧客の住所一覧を取得し、表示するか別の処理を行う
          @addresses = current_customer.addresses
        when 3
          # 「新しいお届け先」が選択された場合の処理
          # 入力されたフォームデータを取得し、その他の処理を行う
          @new_address = @order.address
          @new_postal_code = @order.postal_code
          @new_name = @order.name
        end
        redirect_to confi
      end
      # @cart_items = CartItem.where(customer_id: current_customer.id)
      @total = 0
    end
    
    def thanks
    end
  
    def create
        @order = Order.new(order_params)
      if @order.save
        redirect_to thanks_orders_path
      else
        render :new
      end
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
    
    private

    def order_params
      params.require(:order).permit(:payment_method, :postal_code, :address, :name)
    end
  end
end