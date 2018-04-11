Rails.application.routes.draw do
  root to: 'hooks#index'
  post '/callback', to: 'hooks#callback'
  resources :hooks, only: [:index, :show, :destroy]
end
