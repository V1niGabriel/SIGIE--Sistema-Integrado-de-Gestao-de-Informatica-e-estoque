class Fornecedor < ApplicationRecord
  # Um fornecedor pode fornecer vários itens (produtos)
  has_many :itens, dependent: :restrict_with_error
  
  # Validando o CNPJ para garantir que não tentem salvar algo vazio ou repetido no código também
  validates :nome, :cnpj, presence: true
  validates :cnpj, uniqueness: true
end
