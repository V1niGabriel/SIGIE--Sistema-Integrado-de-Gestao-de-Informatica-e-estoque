class RemoveItemDescricaoFromCompras < ActiveRecord::Migration[8.1]
  def change
    remove_reference :compras, :item, foreign_key: { to_table: :itens }
    remove_column :compras, :descricao, :string
  end
end
