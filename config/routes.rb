Rails.application.routes.draw do
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      get 'user', to: 'users#show'
      post 'user', to: 'users#create'
      put 'user', to: 'users#update'
      delete 'user', to: 'users#destroy'
    end
  end
end
