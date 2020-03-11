Rails.application.routes.draw do
  mount Raddocs::App => "/docs"
  resources :projects do
    resources :tasks, only: [:index, :create]
  end
  resources :tasks, only: [:update, :destroy]
end

