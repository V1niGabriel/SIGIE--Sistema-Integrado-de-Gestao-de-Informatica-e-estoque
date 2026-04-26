# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_04_26_125814) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "cargos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "descricao", limit: 255
    t.decimal "salario_base", precision: 10, scale: 2, null: false
    t.string "titulo", limit: 30, null: false
    t.datetime "updated_at", null: false
  end

  create_table "categorias", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "nome_categoria", limit: 100, null: false
    t.datetime "updated_at", null: false
  end

  create_table "clientes", force: :cascade do |t|
    t.string "cpf_cnpj", limit: 14, null: false
    t.datetime "created_at", null: false
    t.string "email", limit: 100, null: false
    t.string "nome_razao_social", null: false
    t.string "telefone", limit: 11, null: false
    t.datetime "updated_at", null: false
    t.index ["cpf_cnpj"], name: "index_clientes_on_cpf_cnpj", unique: true
  end

  create_table "compras", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "data_vencimento", null: false
    t.string "descricao"
    t.bigint "fornecedor_id", null: false
    t.bigint "item_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.decimal "valor_total", precision: 10, scale: 2, null: false
    t.index ["fornecedor_id"], name: "index_compras_on_fornecedor_id"
    t.index ["item_id"], name: "index_compras_on_item_id"
  end

  create_table "dados_empresas", force: :cascade do |t|
    t.string "bairro", limit: 50, null: false
    t.string "cep", limit: 8, null: false
    t.string "cidade", limit: 50, null: false
    t.string "cnpj", limit: 14, null: false
    t.text "complemento"
    t.datetime "created_at", null: false
    t.string "estado", limit: 2, null: false
    t.string "ie", null: false
    t.string "im", null: false
    t.integer "numero", null: false
    t.string "razao_social", null: false
    t.integer "regime_tributario", null: false
    t.string "rua", limit: 50, null: false
    t.datetime "updated_at", null: false
    t.index ["cnpj"], name: "index_dados_empresas_on_cnpj", unique: true
  end

  create_table "enderecos", force: :cascade do |t|
    t.string "bairro", limit: 50, null: false
    t.string "cep", limit: 8, null: false
    t.string "cidade", limit: 50, null: false
    t.bigint "cliente_id", null: false
    t.text "complemento"
    t.datetime "created_at", null: false
    t.string "estado", limit: 2, null: false
    t.integer "numero", null: false
    t.string "rua", limit: 50, null: false
    t.datetime "updated_at", null: false
    t.index ["cliente_id"], name: "index_enderecos_on_cliente_id"
  end

  create_table "fabricantes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "nome_marca", limit: 100, null: false
    t.datetime "updated_at", null: false
  end

  create_table "fornecedores", force: :cascade do |t|
    t.string "cnpj", limit: 14, null: false
    t.datetime "created_at", null: false
    t.string "email", limit: 100, null: false
    t.string "nome", limit: 80, null: false
    t.string "telefone", limit: 11, null: false
    t.datetime "updated_at", null: false
    t.index ["cnpj"], name: "index_fornecedores_on_cnpj", unique: true
  end

  create_table "funcionarios", force: :cascade do |t|
    t.bigint "cargo_id", null: false
    t.string "cpf", limit: 11, null: false
    t.datetime "created_at", null: false
    t.datetime "data_admissao", null: false
    t.string "email", limit: 100, null: false
    t.string "encrypted_password", default: "", null: false
    t.string "nome", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "telefone", limit: 11, null: false
    t.datetime "updated_at", null: false
    t.index ["cargo_id"], name: "index_funcionarios_on_cargo_id"
    t.index ["cpf"], name: "index_funcionarios_on_cpf", unique: true
    t.index ["email"], name: "index_funcionarios_on_email", unique: true
    t.index ["reset_password_token"], name: "index_funcionarios_on_reset_password_token", unique: true
  end

  create_table "itens", force: :cascade do |t|
    t.bigint "categoria_id", null: false
    t.datetime "created_at", null: false
    t.string "descricao", null: false
    t.bigint "fabricante_id", null: false
    t.bigint "fornecedor_id", null: false
    t.string "ncm", limit: 8
    t.decimal "preco_custo", precision: 10, scale: 2, null: false
    t.decimal "preco_venda", precision: 10, scale: 2, null: false
    t.integer "quantidade_estoque", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["categoria_id"], name: "index_itens_on_categoria_id"
    t.index ["fabricante_id"], name: "index_itens_on_fabricante_id"
    t.index ["fornecedor_id"], name: "index_itens_on_fornecedor_id"
  end

  create_table "itens_orcamento", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "item_id", null: false
    t.bigint "orcamento_id", null: false
    t.decimal "preco_unitario", precision: 10, scale: 2, null: false
    t.integer "quantidade", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_itens_orcamento_on_item_id"
    t.index ["orcamento_id"], name: "index_itens_orcamento_on_orcamento_id"
  end

  create_table "itens_venda", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "item_id", null: false
    t.decimal "preco_unitario", precision: 10, scale: 2, null: false
    t.integer "quantidade", null: false
    t.datetime "updated_at", null: false
    t.bigint "venda_id", null: false
    t.index ["item_id"], name: "index_itens_venda_on_item_id"
    t.index ["venda_id"], name: "index_itens_venda_on_venda_id"
  end

  create_table "movimentacao_estoques", force: :cascade do |t|
    t.bigint "compra_id"
    t.datetime "created_at", null: false
    t.datetime "data", null: false
    t.bigint "funcionario_id", null: false
    t.bigint "item_id", null: false
    t.string "motivo", limit: 255
    t.integer "quantidade", null: false
    t.integer "tipo", null: false
    t.datetime "updated_at", null: false
    t.bigint "venda_id"
    t.index ["compra_id"], name: "index_movimentacao_estoques_on_compra_id"
    t.index ["funcionario_id"], name: "index_movimentacao_estoques_on_funcionario_id"
    t.index ["item_id"], name: "index_movimentacao_estoques_on_item_id"
    t.index ["venda_id"], name: "index_movimentacao_estoques_on_venda_id"
  end

  create_table "orcamentos", force: :cascade do |t|
    t.bigint "cliente_id", null: false
    t.datetime "created_at", null: false
    t.datetime "data_orcamento", null: false
    t.datetime "data_validade", null: false
    t.bigint "funcionario_id", null: false
    t.datetime "updated_at", null: false
    t.index ["cliente_id"], name: "index_orcamentos_on_cliente_id"
    t.index ["funcionario_id"], name: "index_orcamentos_on_funcionario_id"
  end

  create_table "vendas", force: :cascade do |t|
    t.bigint "cliente_id", null: false
    t.datetime "created_at", null: false
    t.datetime "data_venda", null: false
    t.bigint "funcionario_id", null: false
    t.integer "status_pagamento", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["cliente_id"], name: "index_vendas_on_cliente_id"
    t.index ["funcionario_id"], name: "index_vendas_on_funcionario_id"
  end

  add_foreign_key "compras", "fornecedores"
  add_foreign_key "compras", "itens"
  add_foreign_key "enderecos", "clientes"
  add_foreign_key "funcionarios", "cargos"
  add_foreign_key "itens", "categorias"
  add_foreign_key "itens", "fabricantes"
  add_foreign_key "itens", "fornecedores"
  add_foreign_key "itens_orcamento", "itens"
  add_foreign_key "itens_orcamento", "orcamentos"
  add_foreign_key "itens_venda", "itens"
  add_foreign_key "itens_venda", "vendas"
  add_foreign_key "movimentacao_estoques", "compras"
  add_foreign_key "movimentacao_estoques", "funcionarios"
  add_foreign_key "movimentacao_estoques", "itens"
  add_foreign_key "movimentacao_estoques", "vendas"
  add_foreign_key "orcamentos", "clientes"
  add_foreign_key "orcamentos", "funcionarios"
  add_foreign_key "vendas", "clientes"
  add_foreign_key "vendas", "funcionarios"
end
