Rails.application.routes.draw do
  #sync
  post 'sync', to: 'sync#sync'

  #auth
  post 'auth/send_sms'
  post 'auth/verify_code'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
