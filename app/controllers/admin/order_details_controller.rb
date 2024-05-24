# module Admin ←モデル名Adminが存在し、名前がブッキングしてエラーになるのでコメントアウトしてます
class Admin::OrderDetailsController < ApplicationController

  def update
   order_detail = OrderDetail.find(params[:id])
   order_detail.update(making_status: params[:order_detail][:making_status])
   order = order_detail.order
    if params[:order_detail][:making_status] == "manufacturing" #前の画面で「製作中」が選択されたならを定義
       order.update(status:"making") #Orderの注文ステータスを「製作中」に更新する
    end

    if is_all_order_details_making_completed(order) #製作ステータスを全て「製作完了」にしたときに、注文ステータスが「発送準備中」に更新される
      order.update(status: 'preparing_ship')
    end

   flash[:notice] = "制作ステータスを更新しました。"
   redirect_to request.referer
  end


private
    def order_detail_params
      params.require(:order_detail).permit(:making_status)
    end

    def is_all_order_details_making_completed(order)
      order.order_details.each do |order_detail| #order_detailひとつひとつのmaking_statusを判定
        if order_detail.making_status != 'finish' #一つでもmaking_statusがfinishでなければ処理終了
          return false
        end
      end
      return true
    end
end

