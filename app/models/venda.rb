class Venda < ApplicationRecord
  belongs_to :cliente
  belongs_to :funcionario

  # 1. Lembra da tabela ItensVenda? Aqui nós conectamos as duas!
  # O class_name garante que ele ache o Model correto, e o accepts_nested_attributes_for
  # permite salvar tudo junto na mesma tela de Venda.
  has_many :itens_venda, class_name: "ItemVenda", dependent: :destroy
  has_many :movimentacao_estoques, dependent: :destroy
  accepts_nested_attributes_for :itens_venda, allow_destroy: true,
                                              reject_if: proc { |attrs| attrs['item_id'].blank? }

  validate :deve_ter_ao_menos_um_item

  private

  def deve_ter_ao_menos_um_item
    if itens_venda.reject(&:marked_for_destruction?).empty?
      errors.add(:base, "Selecione ao menos um item antes de salvar a venda.")
    end
  end
end
