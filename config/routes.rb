
Rails.application.routes.draw do
  root 'pages#index'
  get 'incidents' => 'pages#index'
  get 'incidents/new' => 'incidents#new'
  get 'incidents/:id' => 'incidents#view'
  get 'incidents/:id/deactivate' => 'incidents#deactivate'
  get 'incidents/:id/edit' => 'incidents#edit'
  get 'incidents/:id/delete' => 'incidents#delete'
  post 'incidents' => 'incidents#create'
  post 'incidents/edit' => 'incidents#edit_incident'
  patch 'incidents/:id/edit' => 'incidents#update'
  delete 'incidents/:id' => 'incidents#delete'
  get 'signout' => 'clearance/sessions#destroy'
  get 'history' => 'pages#history'
  get 'status.svg' => 'pages#current_status_dot', as: 'status_dot'
  post 'subscribers/new' => 'subscribers#create', as: 'create_subscriber'
  get 'subscribers/activate/:activation_key' => 'subscribers#activate', as: 'activate_subscriber'
  get 'subscribers/unsubscribe/:activation_key' => 'subscribers#unsubscribe', as: 'unsubscribe_subscriber'
  if Rails.env == 'development'
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end
end
