Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    resources :users
    resources :sessions, only: [:create, :destroy]
    
    resources :products, only: [:show, :create]
    # user authentication
    post '/login', to: 'sessions#create'
    delete '/logout', to: 'sessions#destroy'
    post '/signup', to: 'users#create'

    # admin product approving
    post '/admin/approve', to: 'admins#approve'
    get '/admin/list_not_approved', to: 'admins#list_not_approved'

    # admin rating
    post '/admin/create_rating_category', to: 'admins#create_rating_category'
    post '/admin/create_product_ratings', to: 'admins#create_product_ratings'

    # comments
    post '/products/:slug/create_comment', to: 'comments#create'
    patch '/products/:slug', to: 'comments#update'
    patch '/products/:slug/rating', to: 'comments#update_rating'
    delete '/products/:slug', to: 'comments#destroy'
    get '/users/:id/comments', to: 'comments#show'

    # likes dislikes
    post '/comments/:id', to: 'user_comment_details#create'
    patch '/comments/:id', to: 'user_comment_details#update'
    delete '/comments/:id/comment_details', to: 'user_comment_details#destroy'

    # reports
    post '/comments/:id/report', to: 'reports#create'
    delete '/reports/:id', to: 'reports#destroy'

    # categories
    post '/categories', to: 'admins#create_category'
    post '/categories/tree', to: 'admins#create_category_tree'
    delete '/categories/tree', to: 'admins#delete_category_tree'
    post '/categories/tree/1', to: 'admins#create_whole_category_tree'
  end
end
