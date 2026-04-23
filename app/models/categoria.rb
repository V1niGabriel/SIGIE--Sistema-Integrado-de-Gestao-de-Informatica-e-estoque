class Categoria < ApplicationRecord
  # Uma categoria possui vários itens vinculados a ela
  has_many :itens, dependent: :restrict_with_error 
  
  # Nota: usei "restrict_with_error" em vez de "destroy" aqui. 
  # Isso é uma boa prática! Significa que o sistema não vai deixar você apagar uma Categoria se já existirem Itens cadastrados nela, 
  # evitando quebrar as suas vendas e orçamentos passados.
end
