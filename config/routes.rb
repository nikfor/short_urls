Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :urls, param: :short_url, only: [:show, :create] do
    get 'stats', on: :member
  end
end
