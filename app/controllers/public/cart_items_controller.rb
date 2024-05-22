module Public

  class CartItemsController < ApplicationController
      before_action :authenticate_customer!

      # カート商品一覧を表示
      def index
        @cart_items = current_customer.cart_items
      end

      # カート商品を追加する
      def create
        cart_item = CartItem.new(cart_item_params)
        cart_item.customer_id = current_customer.id
        cart_item.item_id = cart_item_params[:item_id]
        my_cart_item = current_customer.cart_items.find_by(item_id: params[:cart_item][:item_id])

        if my_cart_item.present?
          my_cart_item = current_customer.cart_items.find_by(item_id: params[:cart_item][:item_id])
          my_cart_item.amount += params[:cart_item][:amount].to_i
          my_cart_item.update(amount: cart_item.amount)
          redirect_to cart_items_path
        else
          if cart_item.save
            redirect_to cart_items_path
          else
            flash[:alert] = cart_item.errors.full_messages.join(', ')
            redirect_to items_path
          end
        end
      end


      # 削除や個数を変更した際、カート商品を再計算する
      def update
          @cart_item = CartItem.find(params[:id])
          #@cart.units += cart_params[:units].to_i
          @cart_item.update(cart_item_params)
          redirect_to cart_items_path
      end

      # カート商品を一つのみ削除
      def destroy
          @cart_item = CartItem.find(params[:id])
          @cart_item.destroy
          flash.now[:alert] = "#{@cart_item.item.name}を削除しました"
          redirect_to cart_items_path
      end

      # カート商品を空ににする
      def all_destroy
          @cart_item = current_customer.cart_items
          @cart_item.destroy_all
          flash[:alert] = "カートの商品を全て削除しました"
          redirect_to customers_cart_items_path
      end


      private
    def cart_item_params
      params.require(:cart_item).permit(:item_id, :amount, :customer_id)
    end

  end

end