require 'sidekiq/web'
Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  resources :products do
    collection do
      post :scrape
    end
  end
end
