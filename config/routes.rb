Rails.application.routes.draw do
  root to: 'rooms#show'
  # get 'rooms/show'
  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
