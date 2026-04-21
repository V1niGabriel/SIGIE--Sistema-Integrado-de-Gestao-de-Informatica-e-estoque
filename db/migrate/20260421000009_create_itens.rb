class CreateItens < ActiveRecord::Migration[8.1]
  def change
    create_table :itens do |t|
      t.references :fornecedor, null: false, foreign_key: { to_table: :fornecedores }
      t.references :categoria, null: false, foreign_key: { to_table: :categorias }
      t.references :fabricante, null: false, foreign_key: { to_table: :fabricantes }
      t.string :descricao, null: false
      t.integer :quantidade_estoque, null: false, default: 0
      t.decimal :preco_custo, precision: 10, scale: 2, null: false
      t.decimal :preco_venda, precision: 10, scale: 2, null: false
      t.string :ncm, limit: 8

      t.timestamps
    end
  end
end
