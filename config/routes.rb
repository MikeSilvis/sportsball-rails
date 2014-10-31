Rails.application.routes.draw do
  resources :scores, only: :show

  root to: 'scores#show'
end
