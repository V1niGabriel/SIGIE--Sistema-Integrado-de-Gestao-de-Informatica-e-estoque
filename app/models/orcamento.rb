class Orcamento < ApplicationRecord
  belongs_to :cliente
  belongs_to :funcionario

  # Conecta o orçamento aos seus itens usando o Model ItemOrcamento que criamos antes
  has_many :itens_orcamento, class_name: "ItemOrcamento", dependent: :destroy
  
  # Permite que o formulário do Orçamento salve os Itens do Orçamento junto
  accepts_nested_attributes_for :itens_orcamento, allow_destroy: true,
                                                  reject_if: proc { |attrs| attrs['item_id'].blank? }

  validate :deve_ter_ao_menos_um_item

  private

  def deve_ter_ao_menos_um_item
    if itens_orcamento.reject(&:marked_for_destruction?).empty?
      errors.add(:base, "Selecione ao menos um item antes de salvar o orçamento.")
    end
  end
end
