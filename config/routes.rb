Rails.application.routes.draw do
  namespace :admin do
    get 'tags/index'
  end
  namespace :admin do
    get 'users/index'
    get 'users/show'
  end
  namespace :public do
    get 'tags/index'
  end
  namespace :public do
    get 'users/show'
    get 'users/edit'
  end
  namespace :public do
    get 'posts/index'
    get 'posts/new'
    get 'posts/show'
    get 'posts/edit'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
