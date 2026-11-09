Rails.application.routes.draw do
  root "pages#home"

  get "about", to: "pages#about"

  resources :vehicles, only: [:index, :show]
  resources :makes, only: [:index, :show]
  resources :categories, only: [:index, :show]
end