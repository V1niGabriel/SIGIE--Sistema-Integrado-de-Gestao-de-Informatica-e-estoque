class AddPermissoesDetalhadasToCargos < ActiveRecord::Migration[8.1]
  def change
    change_table :cargos do |t|
      # VENDAS E ORÇAMENTOS
      t.boolean :visualizar_vendas, default: false
      t.boolean :criar_vendas, default: false
      t.boolean :editar_vendas, default: false
      t.boolean :excluir_vendas, default: false

      t.boolean :visualizar_orcamentos, default: false
      t.boolean :criar_orcamentos, default: false
      t.boolean :editar_orcamentos, default: false
      t.boolean :excluir_orcamentos, default: false

      # CLIENTES
      t.boolean :visualizar_clientes, default: false
      t.boolean :criar_clientes, default: false
      t.boolean :editar_clientes, default: false
      t.boolean :excluir_clientes, default: false

      # ESTOQUE E PRODUTOS
      t.boolean :visualizar_itens, default: false
      t.boolean :criar_itens, default: false
      t.boolean :editar_itens, default: false
      t.boolean :excluir_itens, default: false

      t.boolean :visualizar_fabricantes, default: false
      t.boolean :criar_fabricantes, default: false
      t.boolean :editar_fabricantes, default: false
      t.boolean :excluir_fabricantes, default: false

      t.boolean :visualizar_categorias, default: false
      t.boolean :criar_categorias, default: false
      t.boolean :editar_categorias, default: false
      t.boolean :excluir_categorias, default: false

      t.boolean :visualizar_movimentacoes, default: false
      t.boolean :criar_movimentacoes, default: false
      t.boolean :editar_movimentacoes, default: false
      t.boolean :excluir_movimentacoes, default: false

      # COMPRAS E FORNECEDORES
      t.boolean :visualizar_compras, default: false
      t.boolean :criar_compras, default: false
      t.boolean :editar_compras, default: false
      t.boolean :excluir_compras, default: false

      t.boolean :visualizar_fornecedores, default: false
      t.boolean :criar_fornecedores, default: false
      t.boolean :editar_fornecedores, default: false
      t.boolean :excluir_fornecedores, default: false

      # ADMINISTRAÇÃO (FUNCIONÁRIOS, CARGOS, EMPRESA)
      t.boolean :visualizar_funcionarios, default: false
      t.boolean :criar_funcionarios, default: false
      t.boolean :editar_funcionarios, default: false
      t.boolean :excluir_funcionarios, default: false

      t.boolean :visualizar_cargos, default: false
      t.boolean :criar_cargos, default: false
      t.boolean :editar_cargos, default: false
      t.boolean :excluir_cargos, default: false

      t.boolean :visualizar_empresa, default: false
      t.boolean :editar_empresa, default: false
    end
  end
end