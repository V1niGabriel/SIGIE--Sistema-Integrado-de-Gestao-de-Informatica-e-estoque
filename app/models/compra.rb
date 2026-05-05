class Compra < ApplicationRecord
  belongs_to :fornecedor
  has_many :itens_compra, class_name: "ItemCompra", dependent: :destroy
  has_many :itens, through: :itens_compra
  accepts_nested_attributes_for :itens_compra, allow_destroy: true,
                                               reject_if: proc { |attrs| attrs['item_id'].blank? }

  enum :status, { pendente: 0, pago: 1, cancelado: 2 }

  validates :valor_total, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :data_vencimento, presence: true
end
