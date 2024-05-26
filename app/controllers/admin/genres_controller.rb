# module Admin　←モデル名Adminが存在し、名前がブッキングしてエラーになるのでコメントアウトしてます
  class Admin::GenresController < ApplicationController
    before_action :authenticate_admin!
    
    def index
      @genre = Genre.new
      @genres = Genre.all
    end
  
    def create
      @genre = Genre.new(genre_params)
      if @genre.save
        flash[:notice] = "ジャンルを作成しました。"
        redirect_to admin_genres_path
      else
        @genres = Genre.all
        render :index
      end
    end
    
    def edit
      @genre = Genre.find(params[:id])
    end
  
    def update
      @genre = Genre.find(params[:id])
      if @genre.update(genre_params)
        flash[:notice] = "ジャンルを更新しました。"
        redirect_to admin_genres_path
      else
        render :edit
      end
    end
    
    def destroy
      genre = Genre.find(params[:id])
      genre.destroy
      flash[:notice] = "ジャンルを削除しました。"
      redirect_to admin_genres_path
    end
    
    private

    def genre_params
      params.require(:genre).permit(:name)
    end
  end
# end