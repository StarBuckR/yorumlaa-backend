Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    resources :users
    resources :sessions, only: [:create, :destroy]
    
    resources :products, only: [:show, :create]

    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'

    post '/admin/approve', to: 'admins#approve'
    get '/admin/list_not_approved', to: 'admins#list_not_approved'

    post '/products/:slug/create_comment', to: 'comments#create'
    patch '/products/:slug', to: 'comments#update'
    delete '/products/:slug', to: 'comments#destroy'

    get '/users/:id/comments', to: 'comments#show'
    post '/comments/:id', to: 'user_comment_details#create'
    patch '/comments/:id', to: 'user_comment_details#update'
    delete '/comments/:id', to: 'user_comment_details#destroy'
  end
end
