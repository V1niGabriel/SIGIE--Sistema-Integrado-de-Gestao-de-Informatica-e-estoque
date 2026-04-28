puts "\n=== Inserindo dados de exemplo ==="

# ---- Dependências base (garante que existem) ----
admin = Funcionario.find_by(email: "admin@sigie.com")
abort "⚠️  Execute rails db:seed antes de rodar db:exemplos (usuário admin não encontrado)." unless admin

# ---- Funcionários de exemplo ----
puts "Criando funcionários..."

cargo_admin    = Cargo.find_by!(titulo: "Administrador")
cargo_vendedor = Cargo.find_or_create_by!(titulo: "Vendedor") do |c|
  c.descricao   = "Responsável por vendas e atendimento"
  c.salario_base = 2800.00
end
cargo_gerente  = Cargo.find_or_create_by!(titulo: "Gerente de Vendas") do |c|
  c.descricao   = "Supervisão da equipe comercial"
  c.salario_base = 4500.00
end

funcionarios_data = [
  { nome: "Ana Paula Costa",   email: "ana@sigie.com",    cpf: "98765432100", telefone: "11981112233", cargo: cargo_vendedor, data_admissao: 2.years.ago },
  { nome: "Marcos Oliveira",   email: "marcos@sigie.com", cpf: "87654321099", telefone: "11982223344", cargo: cargo_vendedor, data_admissao: 1.year.ago  },
  { nome: "Patricia Rocha",    email: "patricia@sigie.com", cpf: "76543210988", telefone: "11983334455", cargo: cargo_gerente,  data_admissao: 3.years.ago },
]

funcionarios = funcionarios_data.map do |fd|
  Funcionario.find_or_create_by!(email: fd[:email]) do |f|
    f.nome              = fd[:nome]
    f.password          = "senha123456"
    f.password_confirmation = "senha123456"
    f.cpf               = fd[:cpf]
    f.telefone          = fd[:telefone]
    f.cargo             = fd[:cargo]
    f.data_admissao     = fd[:data_admissao]
  end
end

ana, marcos, patricia = funcionarios

cat_proc    = Categoria.find_or_create_by!(nome_categoria: "Processadores")
cat_placa   = Categoria.find_or_create_by!(nome_categoria: "Placas Mãe")
cat_ram     = Categoria.find_or_create_by!(nome_categoria: "Memórias RAM")
cat_periferico = Categoria.find_or_create_by!(nome_categoria: "Periféricos")
cat_armazenamento = Categoria.find_or_create_by!(nome_categoria: "Armazenamento")
cat_fonte   = Categoria.find_or_create_by!(nome_categoria: "Fontes")

fab_intel   = Fabricante.find_or_create_by!(nome_marca: "Intel")
fab_amd     = Fabricante.find_or_create_by!(nome_marca: "AMD")
fab_asus    = Fabricante.find_or_create_by!(nome_marca: "Asus")
fab_kingston = Fabricante.find_or_create_by!(nome_marca: "Kingston")
fab_seagate = Fabricante.find_or_create_by!(nome_marca: "Seagate")
fab_corsair = Fabricante.find_or_create_by!(nome_marca: "Corsair")
fab_samsung = Fabricante.find_or_create_by!(nome_marca: "Samsung")

forn_tech   = Fornecedor.find_or_create_by!(cnpj: "12345678000190") do |f|
  f.nome = "Distribuidora Tech"; f.telefone = "11988887777"; f.email = "contato@distribuidoratech.com.br"
end
forn_atac   = Fornecedor.find_or_create_by!(cnpj: "98765432000110") do |f|
  f.nome = "Atacadão da Informática"; f.telefone = "11977776666"; f.email = "vendas@atacadaoinfo.com.br"
end

# ---- Clientes ----
puts "Criando clientes..."
clientes_data = [
  { nome_razao_social: "Carlos Souza",           cpf_cnpj: "12345678901",   email: "carlos@email.com",    telefone: "11991112233" },
  { nome_razao_social: "Fernanda Lima",           cpf_cnpj: "23456789012",   email: "fernanda@email.com",  telefone: "11992223344" },
  { nome_razao_social: "Ricardo Mendes",          cpf_cnpj: "34567890123",   email: "ricardo@email.com",   telefone: "11993334455" },
  { nome_razao_social: "Tech Solutions Ltda",     cpf_cnpj: "11222333000181", email: "compras@techsol.com", telefone: "11940001111" },
  { nome_razao_social: "Escola InfoMaster",       cpf_cnpj: "22333444000192", email: "ti@infomaster.edu",   telefone: "11940002222" },
  { nome_razao_social: "Juliana Ferreira",        cpf_cnpj: "45678901234",   email: "juliana@email.com",   telefone: "11994445566" },
  { nome_razao_social: "Bruno Tavares",           cpf_cnpj: "56789012345",   email: "bruno@email.com",     telefone: "11995556677" },
]

clientes = clientes_data.map do |dados|
  Cliente.find_or_create_by!(cpf_cnpj: dados[:cpf_cnpj]) do |c|
    c.nome_razao_social = dados[:nome_razao_social]
    c.email             = dados[:email]
    c.telefone          = dados[:telefone]
  end
end

# ---- Itens ----
puts "Criando itens em estoque..."
itens_data = [
  { descricao: "Processador Intel Core i5-12400",  categoria: cat_proc,         fabricante: fab_intel,   fornecedor: forn_tech, ncm: "84733099", preco_custo: 650.00,  preco_venda: 899.00,  quantidade_estoque: 25 },
  { descricao: "Processador AMD Ryzen 5 5600",     categoria: cat_proc,         fabricante: fab_amd,     fornecedor: forn_tech, ncm: "84733099", preco_custo: 580.00,  preco_venda: 799.00,  quantidade_estoque: 18 },
  { descricao: "Processador Intel Core i7-12700",  categoria: cat_proc,         fabricante: fab_intel,   fornecedor: forn_tech, ncm: "84733099", preco_custo: 1100.00, preco_venda: 1499.00, quantidade_estoque: 10 },
  { descricao: "Placa Mãe Asus B550-F Wi-Fi",      categoria: cat_placa,        fabricante: fab_asus,    fornecedor: forn_atac, ncm: "84734099", preco_custo: 780.00,  preco_venda: 1099.00, quantidade_estoque: 12 },
  { descricao: "Placa Mãe Asus Prime B660M-K",     categoria: cat_placa,        fabricante: fab_asus,    fornecedor: forn_atac, ncm: "84734099", preco_custo: 520.00,  preco_venda: 749.00,  quantidade_estoque: 15 },
  { descricao: "Memória RAM Kingston 8GB DDR4",    categoria: cat_ram,          fabricante: fab_kingston, fornecedor: forn_tech, ncm: "84733012", preco_custo: 110.00,  preco_venda: 169.00,  quantidade_estoque: 50 },
  { descricao: "Memória RAM Kingston 16GB DDR4",   categoria: cat_ram,          fabricante: fab_kingston, fornecedor: forn_tech, ncm: "84733012", preco_custo: 200.00,  preco_venda: 289.00,  quantidade_estoque: 35 },
  { descricao: "Memória RAM Corsair 32GB DDR4",    categoria: cat_ram,          fabricante: fab_corsair,  fornecedor: forn_tech, ncm: "84733012", preco_custo: 370.00,  preco_venda: 529.00,  quantidade_estoque: 20 },
  { descricao: "SSD Samsung 480GB SATA",           categoria: cat_armazenamento, fabricante: fab_samsung, fornecedor: forn_atac, ncm: "84717012", preco_custo: 180.00,  preco_venda: 259.00,  quantidade_estoque: 40 },
  { descricao: "SSD Samsung 1TB NVMe",             categoria: cat_armazenamento, fabricante: fab_samsung, fornecedor: forn_atac, ncm: "84717012", preco_custo: 320.00,  preco_venda: 449.00,  quantidade_estoque: 22 },
  { descricao: "HD Seagate 1TB 7200rpm",           categoria: cat_armazenamento, fabricante: fab_seagate, fornecedor: forn_atac, ncm: "84717013", preco_custo: 190.00,  preco_venda: 269.00,  quantidade_estoque: 30 },
  { descricao: "Fonte Corsair 650W 80Plus Bronze", categoria: cat_fonte,        fabricante: fab_corsair,  fornecedor: forn_tech, ncm: "85044099", preco_custo: 280.00,  preco_venda: 399.00,  quantidade_estoque: 16 },
  { descricao: "Teclado Mecânico Redragon",        categoria: cat_periferico,   fabricante: fab_corsair,  fornecedor: forn_atac, ncm: "84716010", preco_custo: 150.00,  preco_venda: 229.00,  quantidade_estoque: 28 },
  { descricao: "Mouse Gamer Logitech G203",        categoria: cat_periferico,   fabricante: fab_corsair,  fornecedor: forn_atac, ncm: "84716010", preco_custo: 90.00,   preco_venda: 139.00,  quantidade_estoque: 45 },
]

itens = itens_data.map do |dados|
  Item.find_or_create_by!(descricao: dados[:descricao]) do |i|
    i.categoria           = dados[:categoria]
    i.fabricante          = dados[:fabricante]
    i.fornecedor          = dados[:fornecedor]
    i.ncm                 = dados[:ncm]
    i.preco_custo         = dados[:preco_custo]
    i.preco_venda         = dados[:preco_venda]
    i.quantidade_estoque  = dados[:quantidade_estoque]
  end
end

# ---- Orçamentos ----
puts "Criando orçamentos..."

[
  {
    cliente: clientes[3], funcionario: patricia, dias_atras: 10, validade: 5.days.from_now,
    itens: [
      { item: itens[0], qtd: 5,  preco: 899.00  },
      { item: itens[3], qtd: 5,  preco: 1099.00 },
      { item: itens[6], qtd: 10, preco: 289.00  },
    ]
  },
  {
    cliente: clientes[4], funcionario: ana, dias_atras: 5, validade: 25.days.from_now,
    itens: [
      { item: itens[1], qtd: 10, preco: 779.00 },
      { item: itens[4], qtd: 10, preco: 729.00 },
      { item: itens[5], qtd: 20, preco: 159.00 },
      { item: itens[8], qtd: 10, preco: 249.00 },
    ]
  },
  {
    cliente: clientes[0], funcionario: marcos, dias_atras: 2, validade: 1.day.from_now,
    itens: [
      { item: itens[9],  qtd: 1, preco: 449.00 },
      { item: itens[7],  qtd: 1, preco: 529.00 },
      { item: itens[11], qtd: 1, preco: 399.00 },
    ]
  },
].each do |od|
  orc = Orcamento.new(
    cliente:        od[:cliente],
    funcionario:    od[:funcionario],
    data_orcamento: od[:dias_atras].days.ago,
    data_validade:  od[:validade]
  )
  od[:itens].each { |io| orc.itens_orcamento.build(item: io[:item], quantidade: io[:qtd], preco_unitario: io[:preco]) }
  orc.save!
end

# ---- Vendas ----
puts "Criando vendas..."

[
  {
    cliente: clientes[0], funcionario: ana,      status: :pago,        dias_atras: 15,
    itens: [{ item: itens[5], qtd: 2, preco: 169.00 }, { item: itens[12], qtd: 1, preco: 229.00 }]
  },
  {
    cliente: clientes[1], funcionario: marcos,   status: :pago,        dias_atras: 12,
    itens: [{ item: itens[8], qtd: 1, preco: 259.00 }, { item: itens[13], qtd: 1, preco: 139.00 }]
  },
  {
    cliente: clientes[2], funcionario: patricia, status: :processando, dias_atras: 8,
    itens: [{ item: itens[0], qtd: 1, preco: 899.00 }, { item: itens[3], qtd: 1, preco: 1099.00 }, { item: itens[6], qtd: 2, preco: 289.00 }]
  },
  {
    cliente: clientes[3], funcionario: ana,      status: :pago,        dias_atras: 6,
    itens: [{ item: itens[1], qtd: 3, preco: 799.00 }, { item: itens[4], qtd: 3, preco: 749.00 }, { item: itens[5], qtd: 6, preco: 169.00 }]
  },
  {
    cliente: clientes[5], funcionario: marcos,   status: :processando, dias_atras: 3,
    itens: [{ item: itens[9], qtd: 1, preco: 449.00 }, { item: itens[7], qtd: 1, preco: 529.00 }]
  },
  {
    cliente: clientes[6], funcionario: admin,    status: :cancelado,   dias_atras: 2,
    itens: [{ item: itens[2], qtd: 1, preco: 1499.00 }, { item: itens[11], qtd: 1, preco: 399.00 }]
  },
  {
    cliente: clientes[4], funcionario: patricia, status: :processando, dias_atras: 1,
    itens: [{ item: itens[10], qtd: 2, preco: 269.00 }, { item: itens[13], qtd: 4, preco: 139.00 }]
  },
].each do |vd|
  venda = Venda.new(
    cliente:          vd[:cliente],
    funcionario:      vd[:funcionario],
    data_venda:       vd[:dias_atras].days.ago,
    status_pagamento: vd[:status]
  )
  vd[:itens].each { |iv| venda.itens_venda.build(item: iv[:item], quantidade: iv[:qtd], preco_unitario: iv[:preco]) }
  venda.save!

  vd[:itens].each do |iv|
    iv[:item].decrement!(:quantidade_estoque, iv[:qtd])
    MovimentacaoEstoque.create!(
      item:        iv[:item],
      venda:       venda,
      funcionario: admin,
      quantidade:  iv[:qtd],
      tipo:        :saida,
      motivo:      "item vendido",
      data:        vd[:dias_atras].days.ago
    )
  end
end

puts "\n✅ Dados de exemplo inseridos com sucesso!"
puts "   #{funcionarios_data.size} funcionários (Ana, Marcos, Patricia)"
puts "   #{clientes_data.size} clientes"
puts "   #{itens_data.size} itens"
puts "   3 orçamentos"
puts "   7 vendas"
