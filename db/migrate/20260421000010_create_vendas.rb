class CreateVendas < ActiveRecord::Migration[8.1]
  def change
    create_table :vendas do |t|
      t.references :cliente, null: false, foreign_key: true
      t.references :funcionario, null: false, foreign_key: true
      t.datetime :data_venda, null: false
      t.integer :status_pagamento, null: false, default: 0

      t.timestamps
    end
  end
end
