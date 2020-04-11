Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: 'json' } do
    resources :users
    resources :sessions, only: [:create, :destroy]
    
    resources :products

    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'

    post '/admin/approve', to: 'admins#approve'
    get '/admin/list_not_approved', to: 'admins#list_not_approved'
    #post '/products/:slug/create_comment', to 'comments#create'

  end
end
