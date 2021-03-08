Rails.application.routes.draw do
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
