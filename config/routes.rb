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
    resources :orders
    resources :addresses
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