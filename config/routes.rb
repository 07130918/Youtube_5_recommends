Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'youtube#index'
  resources :youtube, only: [:create]
  resources :juntubes, only: [:index]
  resources :ts, only: [:index]
end
