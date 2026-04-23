class Orcamento < ApplicationRecord
  belongs_to :cliente
  belongs_to :funcionario

  # Conecta o orçamento aos seus itens usando o Model ItemOrcamento que criamos antes
  has_many :itens_orcamento, class_name: "ItemOrcamento", dependent: :destroy
  
  # Permite que o formulário do Orçamento salve os Itens do Orçamento junto
  accepts_nested_attributes_for :itens_orcamento, allow_destroy: true
end
