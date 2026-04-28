class ItemVenda < ApplicationRecord
  self.table_name = "itens_venda"

  belongs_to :venda
  belongs_to :item

  validate :quantidade_disponivel_em_estoque

  private

  def quantidade_disponivel_em_estoque
    return unless item && quantidade

    # No edit, o estoque já foi decrementado pela quantidade original,
    # então somamos de volta para saber o que realmente está disponível.
    original = persisted? ? ItemVenda.find(id).quantidade : 0
    disponivel = item.quantidade_estoque + original

    if quantidade > disponivel
      errors.add(:base, "\"#{item.descricao}\" tem apenas #{disponivel} unidade(s) disponível(is) em estoque")
    end
  end
end
