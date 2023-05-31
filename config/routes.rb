Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create] do
        post 'follow/:following_user_id', to: 'users#follow', as: 'follow'
        delete 'unfollow/:following_user_id', to: 'users#unfollow', as: 'unfollow'
      end
    end
  end
end
