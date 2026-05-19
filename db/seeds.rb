# =============================================================================
# SEEDS — Dados de produção
# Execute com: docker compose exec web rails db:seed
# Para dados de exemplo (dev): docker compose exec web rails runner db/exemplos.rb
# =============================================================================

def criar_cargo(titulo:, descricao:, salario_base:, permissoes:)
  cargo = Cargo.find_or_create_by!(titulo: titulo) do |c|
    c.descricao   = descricao
    c.salario_base = salario_base
  end
  cargo.update!(permissoes)
  puts "  ✓ #{titulo}"
  cargo
end

puts "\n=== Cargos ==="

# ── Administrador ────────────────────────────────────────────────────────────
todas = Cargo.column_names
        .select { |col| col.start_with?("criar_", "editar_", "excluir_", "visualizar_") }
        .index_with(true)

cargo_admin = criar_cargo(
  titulo: "Administrador",
  descricao: "Acesso total ao sistema",
  salario_base: 6000.00,
  permissoes: todas
)

# ── Vendedor ─────────────────────────────────────────────────────────────────
# Registra orçamentos, abre vendas, cadastra clientes, consulta estoque
criar_cargo(
  titulo: "Vendedor",
  descricao: "Atendimento e registro de vendas e orçamentos",
  salario_base: 2500.00,
  permissoes: {
    visualizar_vendas:     true, criar_vendas:     true,
    visualizar_orcamentos: true, criar_orcamentos: true, editar_orcamentos: true,
    visualizar_clientes:   true, criar_clientes:   true,
    visualizar_itens:      true,
  }
)

# ── Gestor de Vendas ─────────────────────────────────────────────────────────
# Tudo do vendedor + pode editar/excluir vendas, editar clientes, ver movimentações
criar_cargo(
  titulo: "Gestor de Vendas",
  descricao: "Supervisão da equipe comercial e gestão de vendas",
  salario_base: 4000.00,
  permissoes: {
    visualizar_vendas:     true, criar_vendas:     true, editar_vendas:     true,
    visualizar_orcamentos: true, criar_orcamentos: true, editar_orcamentos: true, excluir_orcamentos: true,
    visualizar_clientes:   true, criar_clientes:   true, editar_clientes:   true,
    visualizar_itens:      true,
    visualizar_movimentacoes: true,
  }
)

# ── Comprador ─────────────────────────────────────────────────────────────────
# Gerencia compras, fornecedores, fabricantes, categorias e itens
criar_cargo(
  titulo: "Gestor de Compras",
  descricao: "Gestão de compras, fornecedores e catálogo de produtos",
  salario_base: 3500.00,
  permissoes: {
    visualizar_compras:     true, criar_compras:     true, editar_compras:     true,
    visualizar_fornecedores: true, criar_fornecedores: true, editar_fornecedores: true,
    visualizar_fabricantes:  true, criar_fabricantes:  true, editar_fabricantes:  true,
    visualizar_categorias:   true, criar_categorias:   true, editar_categorias:   true,
    visualizar_itens:        true, criar_itens:        true, editar_itens:        true
  }
)

# ── Almoxarife ────────────────────────────────────────────────────────────────
# Controla estoque físico e movimentações
criar_cargo(
  titulo: "Almoxarife",
  descricao: "Controle do estoque físico e movimentações de entrada e saída",
  salario_base: 2200.00,
  permissoes: {
    visualizar_itens:        true, criar_itens: true, editar_itens: true,
    visualizar_movimentacoes: true, criar_movimentacoes: true,
    visualizar_compras:       true,
    visualizar_fornecedores:  true,
    visualizar_fabricantes:   true,
    visualizar_categorias:    true,
  }
)

# ── Gerente ───────────────────────────────────────────────────────────────────
# Visão ampla do negócio; pode gerenciar vendas/orçamentos/clientes e ver tudo
criar_cargo(
  titulo: "Gerente",
  descricao: "Gestão geral da operação com acesso amplo de leitura",
  salario_base: 5500.00,
  permissoes: {
    visualizar_vendas:       true, criar_vendas:     true, editar_vendas:    true, excluir_vendas: true,
    visualizar_orcamentos:   true, criar_orcamentos: true, editar_orcamentos: true, excluir_orcamentos: true,
    visualizar_clientes:     true, criar_clientes:   true, editar_clientes:  true, excluir_clientes: true,
    visualizar_itens:        true,
    visualizar_compras:      true,
    visualizar_fornecedores: true,
    visualizar_fabricantes:  true,
    visualizar_categorias:   true,
    visualizar_movimentacoes: true,
    visualizar_funcionarios: true,
    visualizar_cargos:       true,
    editar_empresa:          true, visualizar_empresa: true,
  }
)

puts "\n=== Usuário master ==="
Funcionario.find_or_create_by!(email: "admin@sigie.com") do |f|
  f.nome                  = "Admin Principal"
  f.password              = "senhasegura123"
  f.password_confirmation = "senhasegura123"
  f.cpf                   = "11122233344"
  f.telefone              = "11999999999"
  f.data_admissao         = Date.current
  f.cargo                 = cargo_admin
end
puts "  ✓ admin@sigie.com (senha: senhasegura123)"

puts "\n✅ Seeds concluídos."
puts "   Para carregar dados de exemplo: docker compose exec web rails runner db/exemplos.rb"
