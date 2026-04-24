Rails.application.routes.draw do
  #get "sessions/new"
  resources :movimentacao_estoques
  resources :compras
  resources :itens
  resources :fornecedores
  resources :fabricantes
  resources :categorias
  resources :clientes
  resources :orcamentos
  resources :vendas
  resources :cargos
  resources :funcionarios
  resources :dados_empresas
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
 
  #Rota opcional para acessar /login 
  get 'login', to: 'sessions#new'

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  root "sessions#new"
end
