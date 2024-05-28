class Public::SearchesController < ApplicationController
  
  def genre_searches
    @genres = Genre.all
    @word = params[:word]
    @genre_id = params[:genre_id]
    @genre = Genre.find(@genre_id)
    @search_path = genre_searches_path(@genre_id)
    if @word.present?
      @title = "#{@genre.name}一覧<br>「#{@word}」の検索結果"
      @items = Item.where("name like ? AND genre_id = ?", "%#{@word}%", @genre_id).page(params[:page]).per(9)
    else
      @title = "#{@genre.name}一覧"
      @items = Item.where(genre_id: @genre_id).page(params[:page]).per(9)
    end
    @cart_item_new = CartItem.new
  end
end
