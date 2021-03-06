# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  resources :users, path: 'kajin', only: %i[index show] do
    collection do
      get 'search'
    end
    member do
      get 'followees'
      get 'followers'
      get 'timeline'
      get 'likes'
      get 'notifications'
    end
  end
  resources :posts, path: 'tanka' do
    collection do
      get 'search'
      get 'my-search'
      get 'popular'
    end
    member do
      get 'followers'
    end
  end
  resources :relationships, only: %i[create destroy]
  resources :favorites, only: %i[create destroy]
  resources :infos, path: 'about', only: [:index]
  resources :terms, only: [:index]
  resources :privacy, only: [:index]
  resources :donations, only: [:index]
  get '/users', to: redirect('/users/edit')
  root to: 'posts#popular'
end
