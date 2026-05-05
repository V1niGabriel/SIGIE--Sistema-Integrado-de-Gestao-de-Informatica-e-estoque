class ItemCompra < ApplicationRecord
  self.table_name = "itens_compra"
  belongs_to :compra
  belongs_to :item

  validates :quantidade, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :preco_unitario, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
