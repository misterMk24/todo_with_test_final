Rails.application.routes.draw do
  resources :projects do
    resources :tasks, only: [:index, :create]
  end
  resources :tasks, only: [:update, :destroy]
end

