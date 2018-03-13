Rails.application.routes.draw do
  get 'sync/sync'

  post 'auth/send_sms'

  post 'auth/verify_code'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
