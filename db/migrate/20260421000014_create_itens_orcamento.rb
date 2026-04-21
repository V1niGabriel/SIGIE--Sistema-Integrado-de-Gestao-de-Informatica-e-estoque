class CreateItensOrcamento < ActiveRecord::Migration[8.1]
  def change
    create_table :itens_orcamento do |t|
      t.references :orcamento, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: { to_table: :itens }
      t.integer :quantidade, null: false
      t.decimal :preco_unitario, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end
