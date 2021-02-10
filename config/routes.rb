Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resource  :user,  only: [:create, :show, :update, :destroy]
      resources :tasks, only: [:index, :create, :show, :update, :destroy]
      post   '/login',  to: 'sessions#create'
      delete '/logout', to: 'sessions#destroy'
    end
  end
end
