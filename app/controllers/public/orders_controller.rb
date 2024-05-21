module Public
  class OrdersController < ApplicationController
    def new
      @order = Order.new
      @addresses = Address.all
    end
  
    def confirm
        @order = Order.new(order_params)
    if params[:order][:address_o].to_i == 0
        @order.postal_code = current_customer.postal_code
        @order.address = current_customer.address
        @order.name = current_customer.family_name + current_customer.first_name
    elsif params[:order][:address_o].to_i == 1
        @address = Address.find(params[:order][:address_id])
        @order.postal_code = @address.postal_code
        @order.address = @address.address
        @order.name = @address.name
    elsif params[:order][:address_o].to_i == 2
        @order.customer_id = current_customer.id
    end
        @cart_items = CartItem.where(customer_id: current_customer.id)
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
    end
  
    def show
    end
    
    private

    def order_params
      params.require(:order).permit(:payment_method, :postal_code, :address, :name, :customer_id)
    end
  end
end