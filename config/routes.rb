Rails.application.routes.draw do
  
  devise_for :users,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }
  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end
  
  scope module: :public do
    root 'homes#top'
    
    resources :posts do
      collection do
        get 'search'
        post 'tag_select'
        post 'preview'
        post 'complete'
      end
      
      member do
        patch 'edit_tag'
        patch 'edit_preview'
      end
      
      resource :favorites, only:[:create, :destroy]
      resources :comments, only:[:create, :destroy]
      
    end
    
    resources :users, except: [:new, :create, :index] do
      member do
        get 'confirm'
        get 'follow'
        get 'followed'
      end
      resource :relations, only:[:create, :destroy]
    end
    
    resource :tags, only: [:index, :create] do
      collection do
        get 'search'
        get 'narrow'
      end
    end
    
  end
  
  namespace :admin do
    
    resources :posts, only:[:index, :show] do
      collection do
        get 'search'
      end
      member do
        patch 'restrict_viewing'
      end
    end
    
    patch '/posts/:post_id/comments/:id/restrict_viewing', to: 'comments#restrict_viewing', as: 'restrict_viewing_comment'
    
    resources :users, only:[:index, :show] do
      member do
        patch 'withdraw'
      end
    end
    
    resources :tags, only:[:index, :create] do
      member do
        patch 'disable'
      end
    end
  end

  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
