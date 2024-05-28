module Public
  class ItemsController < ApplicationController
    def index
      @genres = Genre.all
      @word = params[:word]
      @genre_id = params[:genre_id]
      @search_path = items_path
      if @word.present?
        @title = "商品一覧<br>「#{@word}」の検索結果"
        @items = Item.where("name like ?", "%#{@word}%").page(params[:page]).per(9)
      else
        @title = "商品一覧"
        @items = Item.all.page(params[:page]).per(9)
      end
      @cart_item_new = CartItem.new
    end

    def show
      @item = Item.find(params[:id])
      @cart_item_new = CartItem.new
    end
  end
end
