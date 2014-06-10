require 'mail_preview'

PaintAndSip::Application.routes.draw do
  mount MailPreview, :at => '/admin/emails' unless Rails.env.production?
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :venues, only: [:show]
  resources :registrations, only: [:create, :new, :show]

  resources :events, only: [:index, :show] do
    resources :registrations, only: [:create, :new, :show]
  end

  get "/discount_codes", to: 'discount_codes#show', as: 'discount_codes'
  get "/calendar" => "events#index"
  get "/summer-camps" => "summer_camps#index", as: 'summer_camps'
  get "/gallery" => "gallery#index"
  get "/home" => "pages#index"
  get "/:name", to: 'pages#show', as: 'page'
  root to: 'pages#index'
end
