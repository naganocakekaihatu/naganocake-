Rails.application.routes.draw do

  # 顧客用
  # URL /customers/sign_in ...
  devise_for :customers, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }
  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  root :to =>"public/homes#top"
  get "/admin" => "admin/homes#top"

  scope module: :public do
    resources :items
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