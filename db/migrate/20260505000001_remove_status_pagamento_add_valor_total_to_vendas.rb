class RemoveStatusPagamentoAddValorTotalToVendas < ActiveRecord::Migration[8.1]
  def change
    remove_column :vendas, :status_pagamento, :integer
    add_column :vendas, :valor_total, :decimal, precision: 10, scale: 2
  end
end
