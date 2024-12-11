Rails.application.routes.draw do
  resources :products do
    collection do
      post :scrape
    end
  end
end
