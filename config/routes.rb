Rails.application.routes.draw do
  root to: 'welcome#index'
  get '/chat', to: 'rooms#show' #, as: "show"

  post "/webhooks/telegram_#{Rails.application.secrets.my_webhook_token}" => 'webhooks#callback'

  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
