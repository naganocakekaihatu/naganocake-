module Public
  class OrdersController < ApplicationController
    # before_action :authenticate_customer!
    def new
        @order = Order.new
    end
  
    def confirm
      if request.get?  # GETリクエストが来た場合（ページリロード時）
          redirect_to new_order_path
      else  # POSTリクエストが来た場合
          @order = Order.new(order_params)
      if params[:order][:address_o].present? && params[:order][:address_o].to_i == 0 

          @order_postal_code = current_customer.postal_code
          @order_address = current_customer.address
          @order_name = current_customer.family_name + current_customer.first_name
      elsif params[:order][:address_o].present? && params[:order][:address_o].to_i
          @address = Address.find(params[:order][:address_id])
          @order_postal_code = @address.postal_code
          @order_address = @address.address
          @order_name = @address.name
      elsif params[:order][:address_o].to_i == 2 && @order.postal_code.present? && @order.address.present? && @order.name.present?
          @order.customer_id = current_customer.id
          @order_postal_code = @order.postal_code
          @order_address = @order.address
          @order_name = @order.name
      else
          return redirect_to new_order_path if @order.blank?
          session[:order] = nil
          render :new
      end
         
        @cart_items = CartItem.where(customer_id: current_customer.id)
      end
    end
    
    def thanks
    end
  
    def create
      @order = Order.new(order_params)
      @order.customer_id = current_customer.id
      @order.shipping_cost = 800
      @cart_items = CartItem.where(customer_id: current_customer.id)
      ary = []
      @cart_items.each do |cart_item|
        ary << (cart_item.item.price * 1.1) * cart_item.amount
      end
      @cart_items_price = ary.sum
      @order.total_payment = @order.shipping_cost + @cart_items_price
      @order.status = 0
      if @order.save
        @cart_items.each do |cart_item|
          OrderDetail.create!(order_id: @order.id, item_id: cart_item.item.id, price: cart_item.item.price, amount: cart_item.amount, making_status: 0)
        end
        @cart_items.destroy_all
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
      @order_details = @order.order_details.all
      @shipping_fee = 800
      # 計算
      @total = 0
      
      if @order.payment_method.to_i == 0
        @payment_method = "クレジット"
      elsif @order.payment_method.to_i == 1
        @payment_method = "銀行振込"
      end
      
      case @order.status.to_i
      when 0
        @status = "入金待ち"
      when 1
        @status = "入金確認"
      when 2
        @status = "制作中"
      when 3
        @status = "発送準備"
      when 4
        @status = "発送済み"
      end
    end
    
    private

    def order_params
      params.require(:order).permit(:payment_method, :shipping_cost, :total_payment, :status, :postal_code, :address, :name)
    end
    
  end
end