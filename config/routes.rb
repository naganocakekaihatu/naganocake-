Rails.application.routes.draw do

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  devise_for :customers
  
  root :to =>"public/homes#top"
  get "/admin" => "admin/homes#top"
  
  scope module: :public do
    resources :items
    resources :registrations
    resources :sessions
    resources :customers
    resources :cart_items
    resources :orders, only: [:new, :index, :show, :create] do
      get 'confirm', on: :collection
      get 'thanks', on: :collection
    end
    post '/orders/confirm', to: 'orders#confirm', as: 'other_confirm_orders'
    post '/orders/thanks', to: 'orders#thanks', as: 'order_thanks'
    resources :addresses, param: :id, only: [:index, :create, :edit, :updated, :destroy]
  end
    
  namespace :admin do
    resources :sessions
    resources :items
    resources :genres
    resources :customers
    resources :orders
    resources :order_details
  end

end