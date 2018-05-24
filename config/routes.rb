Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/input_data', to: 'solver#main'
  post '/solve', to: 'solver#solve'
  get '/give_star', to: 'solver#give_star', as: 'stars'

  get 'auth', to: 'auth#index'
  root 'auth#index'
end
