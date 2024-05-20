# module Admin ←モデル名Adminが存在し、名前がブッキングしてエラーになるのでコメントアウトしてます
  class Admin::OrdersController < ApplicationController
    # before_action :authenticate_customer!
    def index
    end
    
    def show
      @order = Order.find(params[:id])
      @order_items = @order.order_items
    end
  
    def update
    end
    
  end
# end
