Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  resources :promotions
  resources :product_categories, only: %i[index]
end
