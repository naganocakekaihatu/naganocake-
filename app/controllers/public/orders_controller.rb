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
          @order.postal_code = current_customer.postal_code
          @order.address = current_customer.address
          @order.name = current_customer.family_name + current_customer.first_name
      elsif params[:order][:address_o].present? && params[:order][:address_o].to_i == 1
          @address = Address.find(params[:order][:address_id])
          @order.postal_code = @address.postal_code
          @order.address = @address.address
          @order.name = @address.name
      elsif params[:order][:address_o].to_i == 2 && @order.postal_code.present? && @order.address.present? && @order.name.present?
          @order.customer_id = current_customer.id
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