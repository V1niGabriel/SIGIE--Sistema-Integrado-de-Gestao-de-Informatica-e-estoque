class ItemVenda < ApplicationRecord
  # Força o Rails a usar o nome exato da tabela no banco
  self.table_name = "itens_venda"
  
  belongs_to :venda
  belongs_to :item
end
