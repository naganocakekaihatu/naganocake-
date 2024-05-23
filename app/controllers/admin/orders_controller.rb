# module Admin ←モデル名Adminが存在し、名前がブッキングしてエラーになるのでコメントアウトしてます
  class Admin::OrdersController < ApplicationController
    # before_action :authenticate_customer!
    def index
    end

    def show
      @order = Order.find(params[:id])
      # @order_details= OrderDetail.where(order_id: @order.id)
      @order_details = @order.order_details
    end

    def update
      order = Order.find(params[:id])
      order.update(order_params)
      flash[:notice] = "注文ステータスを更新しました。"
      redirect_to admin_order_path(order.id)
    end

  end

    private

    def order_params
      params.require(:order).permit(:status)
    end
# end
