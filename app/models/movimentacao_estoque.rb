class MovimentacaoEstoque < ApplicationRecord
  belongs_to :funcionario
  belongs_to :item

  # Como são opcionais na migration, marcamos como optional: true no Rails
  belongs_to :venda, optional: true
  belongs_to :compra, optional: true

  # 0 para Entrada (Soma no estoque), 1 para Saída (Subtrai)
  enum :tipo, { entrada: 0, saida: 1 }

  validates :quantidade, :tipo, :data, presence: true
  validates :quantidade, numericality: { greater_than: 0 }
end
