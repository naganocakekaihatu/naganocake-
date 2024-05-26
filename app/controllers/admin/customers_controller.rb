# module Admin　←モデル名Adminが存在し、名前がブッキングしてエラーになるのでコメントアウトしてます
  class Admin::CustomersController < ApplicationController
    def index
      @word = params[:word]
      
      if @word.present?
        @title = "「#{@word}」の検索結果"
        @customers = Customer.where("CONCAT(family_name, first_name) LIKE ?", "%#{@word}%").page(params[:page]).per(10)
      else
        @title = "会員一覧"
        @customers = Customer.page(params[:page]).per(10)
      end
    end

    def show
      @customer = Customer.find(params[:id])
    end

    def edit
      @customer = Customer.find(params[:id])
    end

    def update
      customer = Customer.find(params[:id])
      customer.update(customer_params)
      flash[:notice] = "編集が完了しました。"
      redirect_to admin_customer_path(customer.id)
    end

    private

    def customer_params
      params.require(:customer).permit(:family_name, :first_name, :family_name_kana, :first_name_kana, :telephone_number, :postal_code, :address, :email, :is_deleted)
    end
  end
# end