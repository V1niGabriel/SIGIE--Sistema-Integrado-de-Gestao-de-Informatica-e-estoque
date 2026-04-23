class Cliente < ApplicationRecord
  # Um cliente tem muitos orçamentos e vendas
  has_many :orcamentos, dependent: :destroy
  has_many :vendas, dependent: :destroy

  # Um cliente tem um endereço (que criamos lá atrás como "somente model")
  has_one :endereco, dependent: :destroy

  # Isso é o que permite o formulário do Cliente salvar os dados de Endereço na mesma tela!
  accepts_nested_attributes_for :endereco, allow_destroy: true
end
