Rails.application.routes.draw do

  # 1. AUTENTICAÇÃO (Devise)
  # Aletera o caminho para 'auth' para não conflitar com o CRUD de funcionários.
  # URL de login será: http://localhost:3000/auth/login
  devise_for :funcionarios, path: 'auth', path_names: { 
    sign_in: 'login', 
    sign_out: 'logout',
    password: 'senha'
  }

  # 2 RECURSOS DO SISTEMA (scaffolds)
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

  # 3 PÁGINA INICIAL DO SISTEMA
  # Defines the root path route ("/")
  # root "posts#index"
  root "vendas#index"
end
