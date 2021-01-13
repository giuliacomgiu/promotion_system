Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  resources :promotions do
    post 'issue_coupons', on: :member
  end
  resources :product_categories
  resources :coupons, only: [] do
    put :archive, on: :member
  end
end
