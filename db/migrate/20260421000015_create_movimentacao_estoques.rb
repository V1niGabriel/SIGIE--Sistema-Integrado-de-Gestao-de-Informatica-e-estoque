class CreateMovimentacaoEstoques < ActiveRecord::Migration[8.1]
  def change
    create_table :movimentacao_estoques do |t|
      t.references :funcionario, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: { to_table: :itens }
      t.references :venda, null: true, foreign_key: true
      t.references :compra, null: true, foreign_key: true
      t.integer :tipo, null: false
      t.integer :quantidade, null: false
      t.string :motivo, limit: 255
      t.datetime :data, null: false

      t.timestamps
    end
  end
end
