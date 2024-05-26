# module Admin　←モデル名Adminが存在し、名前がブッキングしてエラーになるのでコメントアウトしてます
  class Admin::CustomersController < ApplicationController
    before_action :authenticate_admin!

    def index
      @customers = Customer.page(params[:page])
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