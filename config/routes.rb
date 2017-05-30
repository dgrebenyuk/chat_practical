Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  root to: 'rooms#show'

  # get 'room/show'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
