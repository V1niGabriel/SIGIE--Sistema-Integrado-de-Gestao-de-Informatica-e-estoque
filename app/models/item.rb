class Item < ApplicationRecord
  belongs_to :fornecedor
  belongs_to :categoria
  belongs_to :fabricante

  # Relacionamentos com as tabelas de itens de venda/orçamento que criamos antes
  has_many :itens_venda, class_name: "ItemVenda"
  has_many :itens_orcamento, class_name: "ItemOrcamento"

  # Validações básicas de segurança
  validates :descricao, presence: true
  validates :quantidade_estoque, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :preco_custo, :preco_venda, numericality: { greater_than: 0 }
end
