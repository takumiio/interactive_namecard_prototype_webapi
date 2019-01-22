Rails.application.routes.draw do
  post "namecard_requesting", to: 'namecard_requseting#create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
