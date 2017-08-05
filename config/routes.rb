Rails.application.routes.draw do
    get 'notification/index'
    get 'notification/background_job'
    post 'notification/create'
    root 'statistic#home'
    get 'login', to: 'session#new'
    post 'login', to: 'session#create'
    delete 'logout', to: 'session#destroy'
    resource 'vouchers'
    resource 'users'
    resource 'dishes'
    resource 'tables'
    resource 'categories'
    resource 'price_change_histories'
    resource 'materials'
    post 'notify_webapp', to: 'pay_pal#notify_webapp'
    get 'refund', to: 'pay_pal#refund'
    get 'rejected_order', to: 'pay_pal#rejected_order'
    get 'send_money', to: 'pay_pal#send_money'
    get 'getEmail', to: 'pay_pal#getEmail'
    post 'executeSendMoney', to: 'pay_pal#executeSend'
    get 'make_statistic', to: 'statistic#make_statistic'
    get 'dishes/updateStatus', to: 'dishes#update_status'
    get 'tables/updateStatus', to: 'tables#update_status'
    get 'categories/updateStatus', to: 'categories#update_status'
    get 'setScheduler', to: 'statistic#setScheduler'
    get 'scheduler', to: 'statistic#scheduler'
    get 'home', to: 'statistic#home'
    get 'dashboard', to: 'statistic#index'
    get 'current_order', to: 'statistic#current_order'
    get 'cancel_order', to: 'pay_pal#cancel_order'
    resources :fakes, only: [:index]
    devise_for :users
    require 'sidekiq/web'
    mount Sidekiq::Web => '/side'

    namespace :api do
        scope module: :v1, constraints: ApiConstraint.new(version: :v1) do
            get 'home', to: 'home#index'
            resources :users, only: [:show, :create, :update] do
                collection do
                    get :balance
                    post :add_voucher
                end
            end

            resources :vouchers do
                collection do
                    post :check_balance_code
                end

            end
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
                    get :search_all
                    post :register_reg_token
                    post :disable_dish
                    get :check_dish_available
                    get :dish_suggestion
                end
            end

            resources :notifications do
                collection do
                    post :register_reg_token
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
                    post :list_dish_done
                    post :remove_dish # mon an remove khoi menu vi nhet nguyen lieu
                    post :reject_order # order bi reject boi chef
                    get :all_order # get toan bo order
                    post :mark_order_accept
                    post :mark_order_reject
                    get :order_in_time
                    get :is_in_time_order
                    post :fully_refund
                    post :partial_refund
                    get :table_dish
                    post :notify_order_detail_not_available
                    post :mark_order_detail_served
                    post :mark_list_order_detail_served
                    post :create_by_cash
                    post :payed_by_cash
                end
            end

            resources :materials, only: [:index] do
                collection do
                    post :mark_not_available
                    post :mark_available
                end
            end

        end
    end
end
