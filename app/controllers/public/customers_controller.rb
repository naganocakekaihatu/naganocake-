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
        redirect_to customer_path(customer)
      else
        @customer = current_customer
        render :edit
      end
    end
  
    def unsubscribe
    end
  
    def withdraw
    end
    
    private

    def customer_params
      params.require(:customer).permit(:family_name, :first_name, :family_name_kana, :first_name_kana, :email, :telephone_number, :postal_code, :address, :password)
    end
  end
end