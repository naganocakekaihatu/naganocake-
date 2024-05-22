module Public
  class ItemsController < ApplicationController
    def index
      @items = Item.page(params[:page])
      @cart_item_new = CartItem.new
    end

    def show
      @item = Item.find(params[:id])
      @cart_item_new = CartItem.new
    end
  end
end
