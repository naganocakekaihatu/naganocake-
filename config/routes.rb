Rails.application.routes.draw do




  # 顧客用
  # URL /customers/sign_in ...
  devise_for :customers, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }
  devise_scope :customer do
    get '/customers/sign_out' => 'public/sessions#destroy' #ログアウトできなくなったので追加
  end
  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }
  devise_scope :admin do
    get '/admin/sign_out' => 'admin/sessions#destroy' #ログアウトできなくなったので追加
  end


  root :to =>"public/homes#top"
  get "/about" => "public/homes#about"
  get "/admin" => "admin/homes#top"

  scope module: :public do
    resources :items
    resources :customers
    resources :cart_items
    resources :orders, only: [:new, :index, :show, :create] do
      get 'confirm', on: :collection
      get 'thanks', on: :collection
    end
    post '/orders/confirm', to: 'orders#confirm', as: 'other_confirm_orders'
    post '/orders/thanks', to: 'orders#thanks', as: 'order_thanks'
    resources :addresses, param: :id, only: [:index, :create, :edit, :update, :destroy]
  end
    
  namespace :admin do
    resources :items
    resources :genres
    resources :customers
    resources :orders
    resources :order_details
  end

end