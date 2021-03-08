Rails.application.routes.draw do

  get '/apps/:access_token/chats/count', to: 'apps#get_chat_counts'
  delete '/apps/:access_token/delete', to: 'apps#delete_app' 
  post 'rooms/create', to: 'rooms#create'
  resources :apps
  devise_for :users,
             controllers: {
               sessions: 'sessions',
               registrations: 'registrations'
             }

  root controller: :apps, action: :index
  
  resources :room_messages
  resources :room_search_messages
  resources :rooms
  resources :applicationchats
  resources :apps
  
end
