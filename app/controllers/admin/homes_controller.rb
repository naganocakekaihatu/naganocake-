# module Admin ←モデル名Adminが存在し、名前がブッキングしてエラーになるのでコメントアウトしてます
  class Admin::HomesController < ApplicationController
    def top
      @orders = Order.all
    end
  end
# end
