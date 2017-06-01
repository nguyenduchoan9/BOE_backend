Rails.application.routes.draw do
  root 'statistic#index'
  get 'login', to: 'session#new'
  post 'login', to: 'session#create'
  delete 'logout', to: 'session#destroy'
  resource 'users'

  devise_for :users



  namespace :api do
    scope module: :v1, constraints: ApiConstraint.new(version: :v1) do
      get 'home', to: 'home#index'
      resources :users, only: [:show, :create, :update]
      resources :sessions, only: [:create, :destroy]
      resources :notes, only: [:index, :create, :show, :update, :destroy]
    end
  end

end
