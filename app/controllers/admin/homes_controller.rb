# module Admin ←モデル名Adminが存在し、名前がブッキングしてエラーになるのでコメントアウトしてます
  class Admin::HomesController < ApplicationController
    before_action :authenticate_admin!
    def top
      @orders = Order.page(params[:page])
    end
  end
# end
