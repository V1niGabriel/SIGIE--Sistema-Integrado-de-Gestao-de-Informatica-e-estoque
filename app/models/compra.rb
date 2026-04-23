class Compra < ApplicationRecord
  belongs_to :fornecedor
  belongs_to :item

  # Mapeando o status (0: pendente, 1: pago, 2: cancelado)
  enum status: { pendente: 0, pago: 1, cancelado: 2 }

  validates :valor_total, numericality: { greater_than_or_equal_to: 0 }
  validates :data_vencimento, presence: true
end
