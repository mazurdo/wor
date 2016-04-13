Wor::Engine.routes.draw do
  get 'posts', :to => 'wor/posts#index', :as => :posts
  get 'posts/:slug', :to => 'wor/posts#show', :as => :post
  get 'posts/preview/:id', :to => 'wor/posts#preview', :as => :post_preview

  get 'categories/:slug', :to => 'wor/categories#show', :as => :category
  get 'tags/:slug', :to => 'wor/tags#show', :as => :tag

  get  'wor/sitemap', :to => 'wor/sitemap#index', :as => :sitemap
  get  'wor/sitemap/tags', :to => 'wor/sitemap#tags', :as => :sitemap_tags
  get  'wor/sitemap/categories', :to => 'wor/sitemap#categories', :as => :sitemap_categories
  get  'wor/sitemap/posts', :to => 'wor/sitemap#posts', :as => :sitemap_posts


  namespace :wor do
    namespace :api do
      namespace :v1 do
        resources :posts do
          post 'upload_cover_image', :to => 'posts#upload_cover_image'
        end
        resources :classifiers
        resources :users, only: [:index]
        resources :versions, only: [:index]
        resources :config_data, only: [:index]
      end
    end

    namespace :admin do
      get '*other', :to => 'dashboard#index'
    end
  end

  get '/wor/elfinder_manager', to: 'wor/elfinder#index'
  match '/wor/elfinder' => 'wor/elfinder#elfinder', via: [:get, :post]

  root :to => 'home#index'
  match 'elfinder' => 'home#elfinder'

  root :to => 'wor/posts#index'
end
