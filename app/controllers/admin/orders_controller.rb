# module Admin ←モデル名Adminが存在し、名前がブッキングしてエラーになるのでコメントアウトしてます
  class Admin::OrdersController < ApplicationController
    # before_action :authenticate_customer!
    before_action :authenticate_admin!
    def index
    end

    def show
      @order = Order.find(params[:id])
      # @order_details= OrderDetail.where(order_id: @order.id)
      @order_details = @order.order_details

    end

    def update
      order = Order.find(params[:id])
      order.update(status: params[:order][:status])
      order_details = order.order_details

      if params[:order][:status] == "confirm_payment" #前の画面で「入金確認」が選択されたならを定義
        order_details.update(making_status:"waiting_manufacture") #Order_detailの制作ステータスを「製作待ち」に更新する
      end

      flash[:notice] = "注文ステータスを更新しました。"
      redirect_to admin_order_path(order.id)
    end

  end

    private

    def order_params
      params.require(:order).permit(:status)
    end
# end
