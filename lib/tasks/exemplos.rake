namespace :db do
  desc "Insere dados de exemplo: clientes, itens, orçamentos e vendas"
  task exemplos: :environment do
    load Rails.root.join("db/exemplos.rb")
  end
end
