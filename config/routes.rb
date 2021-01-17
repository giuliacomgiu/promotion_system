Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  resources :promotions do
    post 'issue_coupons', on: :member
    get :search, on: :collection
  end
  resources :product_categories
  resources :coupons, only: [] do
    put :archive, :reactivate, on: :member
    get :search, on: :collection
  end

  namespace :api do
    namespace :v1 do
      get 'coupons/:code', to: 'coupons#show'
    end
  end
end
