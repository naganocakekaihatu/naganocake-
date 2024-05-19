module Admin
  class ItemsController < ApplicationController
    def index
      @items = Item.all
    end

    def new
      @item = Item.new
      @genres = Genre.all
    end

    def create
      @item = Item.new(item_params)
      if @item.save
        flash[:notice] = "商品を追加しました。"
        redirect_to admin_item_path(@item)
      else
        @genres = Genre.all
        render :new
      end
    end

    def show
      @item = Item.find(params[:id])
    end

    def edit
      @item = Item.find(params[:id])
      @genres = Genre.all
    end

    def update
      @item = Item.find(params[:id])
      if @item.update(item_params)
        flash[:notice] = "商品を更新しました。"
        redirect_to admin_item_path(@item.id)
      else
        @genres = Genre.all
        render :edit
      end
    end

    def destroy
      item = Item.find(params[:id])
      item.destroy
      flash[:notice] = "商品を削除しました。"
      redirect_to admin_items_path
    end

    private

    def item_params
      params.require(:item).permit(:image, :genre_id, :name, :price, :introduction, :is_active)
    end
  end
end