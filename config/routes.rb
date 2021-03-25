Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resource :bullet, only: :show
  resource :in_fine, only: :show
  resource :standard, only: :show
  resource :linear, only: :show

end
