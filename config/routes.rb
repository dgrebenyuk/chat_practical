Rails.application.routes.draw do
  root to: 'rooms#show'
  # get 'webhooks/callback'
  post '/webhooks/telegram_e9ceekfi3p97bn2lc6al7nf54rfen0lgnsab825qkx6ks7hgjllsokkl33j' => 'webhooks#callback'

  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
