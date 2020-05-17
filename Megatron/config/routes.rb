Rails.application.routes.draw do
  scope :api do
    namespace :v1 do
      resources :brands, only: [:index, :show, :update, :create]
      resources :series, only: [:index, :show, :update, :create]
      resources :styles, only: :index
    end
  end
end
