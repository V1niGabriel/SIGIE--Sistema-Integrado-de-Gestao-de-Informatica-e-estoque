class ItemOrcamento < ApplicationRecord
  # Força o Rails a usar o nome exato da tabela no banco
  self.table_name = "itens_orcamento"

  belongs_to :orcamento
  belongs_to :item
end
