class CreateOrcamentos < ActiveRecord::Migration[8.1]
  def change
    create_table :orcamentos do |t|
      t.references :cliente, null: false, foreign_key: true
      t.references :funcionario, null: false, foreign_key: true
      t.datetime :data_orcamento, null: false
      t.datetime :data_validade, null: false

      t.timestamps
    end
  end
end
