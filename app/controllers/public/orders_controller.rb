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
      @order = Order.new
      @order.customer_id = current_customer.id
      @order.shipping_fee = 800
      @cart_items = CartItem.where(customer_id: current_customer.id)
      ary = []
      @cart_items.each do |cart_item|
        ary << cart_item.item.price*cart_item.quantity
      end
      @cart_items_price = ary.sum
      @order.total_price = @order.shipping_fee + @cart_items_price
      @order.pay_method = params[:order][:pay_method]
      if @order.pay_method == "credit_card"
        @order.status = 1
      else
        @order.status = 0
      end
      
      
      address_type = params[:order][:address_type]
      case address_type
      when "customer_address"
        @order.post_code = current_member.post_code
        @order.address = current_customer.address
        @order.name = current_customer.family_name + current_customer.first_name
      when "registered_address"
        Addresse.find(params[:order][:registered_address_id])
        selected = Addresse.find(params[:order][:registered_address_id])
        @order.post_code = selected.post_code
        @order.address = selected.address
        @order.name = selected.name
      when "new_address"
        @order.post_code = params[:order][:new_post_code]
        @order.address = params[:order][:new_address]
        @order.name = params[:order][:new_name]
      end
      
      if @order.save
        if @order.status == 0
          @cart_items.each do |cart_item|
            OrderDetail.create!(order_id: @order.id, item_id: cart_item.item.id, price: cart_item.item.price, quantity: cart_item.quantity, making_status: 0)
          end
        else
          @cart_items.each do |cart_item|
            OrderDetail.create!(order_id: @order.id, item_id: cart_item.item.id, price: cart_item.item.price, quantity: cart_item.quantity, making_status: 1)
          end
        end
        @cart_items.destroy_all
        redirect_to complete_orders_path
      else
        render :items
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