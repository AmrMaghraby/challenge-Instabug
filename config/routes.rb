Rails.application.routes.draw do

  get '/apps/:access_token/chats/count', to: 'apps#get_chat_counts'
  get '/rooms/:app_token/chats/:chat_number/messages/count', to: 'rooms#get_chat_counts'
  get '/messages/:app_token/chats/:chat_number/display', to: 'room_messages#get_messages_under_specif_chat'
  delete '/rooms/:app_token/chats/:chat_number/messages/count', to: 'rooms#delete_room'
  delete '/apps/:access_token/delete', to: 'apps#delete_app'
  delete '/message/:id/delete', to: 'room_messages#delete' 
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
