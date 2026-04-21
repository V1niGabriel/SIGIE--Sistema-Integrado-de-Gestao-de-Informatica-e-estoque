class CreateCompras < ActiveRecord::Migration[8.1]
  def change
    create_table :compras do |t|
      t.references :fornecedor, null: false, foreign_key: { to_table: :fornecedores }
      t.references :item, null: false, foreign_key: { to_table: :itens }
      t.string :descricao
      t.decimal :valor_total, precision: 10, scale: 2, null: false
      t.datetime :data_vencimento, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
