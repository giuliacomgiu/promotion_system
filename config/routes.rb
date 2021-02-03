Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  resources :promotions do
    post 'issue_coupons', on: :member
    get :search, on: :collection
    put :approve, on: :member
  end
  resources :product_categories
  resources :coupons, only: [] do
    put :archive, :reactivate, on: :member
    get :search, on: :collection
  end

  namespace :api do
    namespace :v1 do
      resources :coupons, param: :code, only: %i[show] do
        patch :burn, on: :member
      end
    end
  end
end
