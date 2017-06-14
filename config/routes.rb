Rails.application.routes.draw do
    get 'notification/index'
    get 'notification/background_job'

    post 'notification/create'
    get 'price_change_histories/show'

    get 'price_change_histories/new'

    get 'price_change_histories/create'

    get 'price_change_histories/edit'

    get 'price_change_histories/update'

    root 'statistic#index'
    get 'login', to: 'session#new'
    post 'login', to: 'session#create'
    delete 'logout', to: 'session#destroy'
    resource 'users'
    resource 'tables'
    resource 'memberships'
    resource 'discount_days'
    resource 'dishes'
    get 'make_statistic', to: 'statistic#make_statistic'

    devise_for :users

    require 'sidekiq/web'
    mount Sidekiq::Web => '/side'

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
                    get :search_cutlery
                    get :search_drinking
                    post :register_reg_token
                    post :disable_dish
                end
            end

            resources :notifications do
                collection do
                    post :register_reg_token
                end
            end

            resources :orders, only: [:create, :index] do
                collection do
                    get :order_history
                    post :dish_done # mon an duoc lam xong
                    post :remove_dish # mon an remove khoi menu vi nhet nguyen lieu
                    post :reject_order # order bi reject boi chef
                    get :all_order # get toan bo order
                    post :mark_order_accept
                    post :mark_order_reject
                    get :order_in_time
                end
            end
        end
    end
end
