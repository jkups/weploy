Rails.application.routes.draw do
  #session routes
  get '/login' => 'session#new'
  post '/login' => 'session#create'
  delete '/login' => 'session#destroy'

  resources :users, :timesheets
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
