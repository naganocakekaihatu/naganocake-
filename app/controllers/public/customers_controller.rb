module Public
  class CustomersController < ApplicationController
    def show
      @customer = current_customer
    end

    def edit
      @customer = current_customer
    end

    def update
      customer = current_customer
      if customer.update(customer_params)
        flash[:notice] = "編集が完了しました。"
        redirect_to customer_path(customer)
      else
        @customer = current_customer
        render :edit
      end
    end

    def unsubscribe
    end

    def withdraw
      customer = Customer.find(current_customer.id)
      # is_deletedカラムをfalseに変更することにより削除フラグを立てる
      customer.update(is_deleted: false)
      reset_session
      flash[:notice] = "退会が完了しました。"
      # flash[:notice] = "退会処理を実行いたしました"
      redirect_to root_path
    end

    private

    def customer_params
      params.require(:customer).permit(:family_name, :first_name, :family_name_kana, :first_name_kana, :email, :telephone_number, :postal_code, :address, :password)
    end
  end
end