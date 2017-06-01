Rails.application.routes.draw do

    namespace :api do
        scope module: :v1, constraints: ApiConstraint.new(version: :v1) do
            get 'home', to: 'home#index'
            resources :users, only: [:show,:create, :update]
            resources :sessions, only: [:create, :destroy]
            resources :dishes, only: [:index, :show, :update, :destroy] do
                member do
                    get :cutlery
                    get :drinking
                end
                collection do
                    get :by_category
                    get :as_cart
                end
            end
        end
    end
end
