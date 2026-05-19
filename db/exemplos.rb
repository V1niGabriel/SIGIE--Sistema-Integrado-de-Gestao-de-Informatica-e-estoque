# =============================================================================
# EXEMPLOS — Simulação realista de ~14 meses de operação
# Execute com: docker compose exec web rails runner db/exemplos.rb
# =============================================================================

puts "\n=== Verificando pré-requisitos ==="
admin = Funcionario.find_by(email: "admin@sigie.com")
abort "⚠️  Execute 'rails db:seed' antes (usuário admin não encontrado)." unless admin

cargo_vendedor      = Cargo.find_by!(titulo: "Vendedor")
cargo_gestor_vendas = Cargo.find_by!(titulo: "Gestor de Vendas")
cargo_comprador     = Cargo.find_by!(titulo: "Gestor de Compras")
cargo_almoxarife    = Cargo.find_by!(titulo: "Almoxarife")
cargo_gerente       = Cargo.find_by!(titulo: "Gerente")
puts "  ✓ Cargos encontrados"

# =============================================================================
puts "\n=== Funcionários ==="
# =============================================================================

funcionarios_data = [
  { nome: "Ana Paula Costa",    email: "ana@sigie.com",      cpf: "98765432100", tel: "11981112233", cargo: cargo_vendedor,      admissao: 2.years.ago   },
  { nome: "Marcos Oliveira",    email: "marcos@sigie.com",   cpf: "87654321099", tel: "11982223344", cargo: cargo_vendedor,      admissao: 18.months.ago },
  { nome: "Patricia Rocha",     email: "patricia@sigie.com", cpf: "76543210988", tel: "11983334455", cargo: cargo_gestor_vendas, admissao: 3.years.ago   },
  { nome: "Diego Santana",      email: "diego@sigie.com",    cpf: "65432109877", tel: "11984445566", cargo: cargo_comprador,     admissao: 2.years.ago   },
  { nome: "Renata Alves",       email: "renata@sigie.com",   cpf: "54321098766", tel: "11985556677", cargo: cargo_almoxarife,    admissao: 14.months.ago },
  { nome: "Fernando Nunes",     email: "fernando@sigie.com", cpf: "43210987655", tel: "11986667788", cargo: cargo_gerente,       admissao: 4.years.ago   },
  { nome: "Camila Ramos",       email: "camila@sigie.com",   cpf: "32109876544", tel: "11987778899", cargo: cargo_vendedor,      admissao: 10.months.ago },
  { nome: "Lucas Pimentel",     email: "lucas@sigie.com",    cpf: "21098765433", tel: "11988889900", cargo: cargo_vendedor,      admissao: 7.months.ago  },
]

funcionarios = funcionarios_data.map do |fd|
  f = Funcionario.find_or_create_by!(email: fd[:email]) do |func|
    func.nome = fd[:nome]; func.password = "senha123456"; func.password_confirmation = "senha123456"
    func.cpf = fd[:cpf]; func.telefone = fd[:tel]; func.cargo = fd[:cargo]; func.data_admissao = fd[:admissao]
  end
  puts "  ✓ #{fd[:nome]} (#{fd[:cargo].titulo})"
  f
end
ana, marcos, patricia, diego, renata, fernando, camila, lucas = funcionarios
vendedores = [ana, marcos, patricia, camila, lucas]

# =============================================================================
puts "\n=== Categorias ==="
# =============================================================================

cats = {
  proc:      Categoria.find_or_create_by!(nome_categoria: "Processadores"),
  placa:     Categoria.find_or_create_by!(nome_categoria: "Placas Mãe"),
  ram:       Categoria.find_or_create_by!(nome_categoria: "Memórias RAM"),
  video:     Categoria.find_or_create_by!(nome_categoria: "Placas de Vídeo"),
  armazen:   Categoria.find_or_create_by!(nome_categoria: "Armazenamento"),
  fonte:     Categoria.find_or_create_by!(nome_categoria: "Fontes"),
  gabinete:  Categoria.find_or_create_by!(nome_categoria: "Gabinetes"),
  peri:      Categoria.find_or_create_by!(nome_categoria: "Periféricos"),
  monitor:   Categoria.find_or_create_by!(nome_categoria: "Monitores"),
  rede:      Categoria.find_or_create_by!(nome_categoria: "Redes e Conectividade"),
  refriger:  Categoria.find_or_create_by!(nome_categoria: "Refrigeração"),
  notebook:  Categoria.find_or_create_by!(nome_categoria: "Notebooks"),
}
puts "  ✓ #{cats.size} categorias"

# =============================================================================
puts "\n=== Fabricantes ==="
# =============================================================================

fabs = {
  intel:    Fabricante.find_or_create_by!(nome_marca: "Intel"),
  amd:      Fabricante.find_or_create_by!(nome_marca: "AMD"),
  nvidia:   Fabricante.find_or_create_by!(nome_marca: "NVIDIA"),
  asus:     Fabricante.find_or_create_by!(nome_marca: "Asus"),
  gigabyte: Fabricante.find_or_create_by!(nome_marca: "Gigabyte"),
  msi:      Fabricante.find_or_create_by!(nome_marca: "MSI"),
  kingston: Fabricante.find_or_create_by!(nome_marca: "Kingston"),
  corsair:  Fabricante.find_or_create_by!(nome_marca: "Corsair"),
  samsung:  Fabricante.find_or_create_by!(nome_marca: "Samsung"),
  wd:       Fabricante.find_or_create_by!(nome_marca: "Western Digital"),
  seagate:  Fabricante.find_or_create_by!(nome_marca: "Seagate"),
  lg:       Fabricante.find_or_create_by!(nome_marca: "LG"),
  dell:     Fabricante.find_or_create_by!(nome_marca: "Dell"),
  tp_link:  Fabricante.find_or_create_by!(nome_marca: "TP-Link"),
  cooler:   Fabricante.find_or_create_by!(nome_marca: "Cooler Master"),
  redragon: Fabricante.find_or_create_by!(nome_marca: "Redragon"),
}
puts "  ✓ #{fabs.size} fabricantes"

# =============================================================================
puts "\n=== Fornecedores ==="
# =============================================================================

forns = {
  tech:    Fornecedor.find_or_create_by!(cnpj: "12345678000190") { |f| f.nome = "Distribuidora Tech";        f.telefone = "11988887777"; f.email = "contato@distribuidoratech.com.br" },
  atac:    Fornecedor.find_or_create_by!(cnpj: "98765432000110") { |f| f.nome = "Atacadão da Informática";   f.telefone = "11977776666"; f.email = "vendas@atacadaoinfo.com.br" },
  mega:    Fornecedor.find_or_create_by!(cnpj: "55666777000133") { |f| f.nome = "MegaComp Distribuidora";    f.telefone = "11966665555"; f.email = "pedidos@megacomp.com.br" },
  prime:   Fornecedor.find_or_create_by!(cnpj: "33444555000177") { |f| f.nome = "Prime Tecnologia";          f.telefone = "11955554444"; f.email = "comercial@primetech.com.br" },
  global:  Fornecedor.find_or_create_by!(cnpj: "77888999000144") { |f| f.nome = "Global TI Distribuidora";  f.telefone = "11944443333"; f.email = "vendas@globalti.com.br" },
}
puts "  ✓ #{forns.size} fornecedores"

# =============================================================================
puts "\n=== Itens em estoque ==="
# =============================================================================

# [descricao, cat, fab, forn, ncm, custo, venda, qtd_inicial]
itens_spec = [
  # Processadores
  ["Processador Intel Core i3-12100",    :proc,    :intel,    :tech,   "84733099",  380.00,  549.00,  30],
  ["Processador Intel Core i5-12400F",   :proc,    :intel,    :tech,   "84733099",  620.00,  869.00,  25],
  ["Processador Intel Core i7-12700K",   :proc,    :intel,    :tech,   "84733099", 1150.00, 1599.00,  15],
  ["Processador Intel Core i9-12900K",   :proc,    :intel,    :prime,  "84733099", 2100.00, 2899.00,   4],
  ["Processador AMD Ryzen 5 5600",       :proc,    :amd,      :tech,   "84733099",  560.00,  779.00,  20],
  ["Processador AMD Ryzen 7 5800X",      :proc,    :amd,      :tech,   "84733099",  890.00, 1249.00,  12],
  ["Processador AMD Ryzen 9 5900X",      :proc,    :amd,      :prime,  "84733099", 1450.00, 1999.00,   3],
  # Placas Mãe
  ["Placa Mãe Asus Prime B660M-K D4",   :placa,   :asus,     :atac,   "84734099",  500.00,  719.00,  18],
  ["Placa Mãe Asus ROG Strix B550-F",   :placa,   :asus,     :atac,   "84734099",  820.00, 1149.00,  10],
  ["Placa Mãe Gigabyte B550 Aorus Pro", :placa,   :gigabyte, :mega,   "84734099",  750.00, 1059.00,  12],
  ["Placa Mãe MSI MAG B660M Mortar",    :placa,   :msi,      :mega,   "84734099",  680.00,  959.00,  14],
  # Memórias RAM
  ["Memória RAM Kingston 8GB DDR4",      :ram,     :kingston, :tech,   "84733012",  105.00,  159.00,  60],
  ["Memória RAM Kingston 16GB DDR4",     :ram,     :kingston, :tech,   "84733012",  195.00,  289.00,  45],
  ["Memória RAM Kingston 32GB DDR5",     :ram,     :kingston, :prime,  "84733012",  420.00,  599.00,  20],
  ["Memória RAM Corsair Vengeance 16GB", :ram,     :corsair,  :atac,   "84733012",  220.00,  319.00,  30],
  # Placas de Vídeo
  ["Placa de Vídeo NVIDIA RTX 3060",    :video,   :nvidia,   :prime,  "84733099", 1600.00, 2199.00,  10],
  ["Placa de Vídeo NVIDIA RTX 3070",    :video,   :nvidia,   :prime,  "84733099", 2400.00, 3299.00,   2],
  ["Placa de Vídeo AMD RX 6600 XT",     :video,   :amd,      :global, "84733099", 1200.00, 1699.00,   8],
  # Armazenamento
  ["SSD Samsung 480GB SATA",            :armazen, :samsung,  :atac,   "84717012",  175.00,  259.00,  50],
  ["SSD Samsung 1TB NVMe M.2",          :armazen, :samsung,  :atac,   "84717012",  310.00,  449.00,  30],
  ["SSD WD Blue 1TB SATA",              :armazen, :wd,       :mega,   "84717012",  280.00,  399.00,  25],
  ["HD Seagate Barracuda 1TB",          :armazen, :seagate,  :atac,   "84717013",  185.00,  269.00,  35],
  ["HD Seagate Barracuda 2TB",          :armazen, :seagate,  :global, "84717013",  260.00,  379.00,  20],
  # Fontes
  ["Fonte Corsair CV550 80Plus Bronze", :fonte,   :corsair,  :tech,   "85044099",  240.00,  349.00,  22],
  ["Fonte Corsair RM750x 80Plus Gold",  :fonte,   :corsair,  :tech,   "85044099",  490.00,  699.00,  14],
  # Gabinetes
  ["Gabinete Cooler Master Q300L",      :gabinete,:cooler,   :mega,   "85299099",  180.00,  269.00,  20],
  ["Gabinete Cooler Master H500",       :gabinete,:cooler,   :mega,   "85299099",  380.00,  549.00,  10],
  # Monitores
  ["Monitor LG 24\" Full HD IPS",       :monitor, :lg,       :global, "85285299",  680.00,  979.00,  15],
  ["Monitor LG 27\" QHD IPS",           :monitor, :lg,       :global, "85285299", 1100.00, 1549.00,   8],
  ["Monitor Dell 24\" Full HD",         :monitor, :dell,     :prime,  "85285299",  720.00, 1029.00,  10],
  # Periféricos
  ["Teclado Mecânico Redragon K552",    :peri,    :redragon, :atac,   "84716010",  145.00,  219.00,  35],
  ["Mouse Gamer Redragon M602",         :peri,    :redragon, :atac,   "84716010",   75.00,  119.00,  50],
  ["Headset Redragon H510 Zeus",        :peri,    :redragon, :atac,   "85183000",  120.00,  189.00,  28],
  ["Webcam Logitech C920 HD Pro",       :peri,    :lg,       :global, "85258099",  380.00,  549.00,  12],
  # Rede
  ["Switch TP-Link 8 Portas Gigabit",   :rede,    :tp_link,  :mega,   "85176200",  140.00,  209.00,  20],
  ["Roteador TP-Link Archer AX23",      :rede,    :tp_link,  :mega,   "85176200",  280.00,  399.00,  15],
  # Refrigeração
  ["Cooler CPU Cooler Master Hyper 212", :refriger,:cooler,  :mega,   "84145190",  130.00,  199.00,  25],
  # Notebooks
  ["Notebook Dell Inspiron 15 i5",      :notebook,:dell,     :prime,  "84713012", 2800.00, 3799.00,   5],
  ["Notebook Dell Inspiron 15 i7",      :notebook,:dell,     :prime,  "84713012", 3900.00, 5299.00,   3],
]

itens = itens_spec.map do |desc, cat_k, fab_k, forn_k, ncm, custo, venda, qtd|
  Item.find_or_create_by!(descricao: desc) do |i|
    i.categoria = cats[cat_k]; i.fabricante = fabs[fab_k]; i.fornecedor = forns[forn_k]
    i.ncm = ncm; i.preco_custo = custo; i.preco_venda = venda; i.quantidade_estoque = qtd
  end
end
puts "  ✓ #{itens.size} itens"

# =============================================================================
puts "\n=== Clientes ==="
# =============================================================================

clientes_spec = [
  ["Carlos Souza",             "12345678901",    "carlos@email.com",         "11991112233"],
  ["Fernanda Lima",            "23456789012",    "fernanda@email.com",       "11992223344"],
  ["Ricardo Mendes",           "34567890123",    "ricardo@email.com",        "11993334455"],
  ["Juliana Ferreira",         "45678901234",    "juliana@email.com",        "11994445566"],
  ["Bruno Tavares",            "56789012345",    "bruno@email.com",          "11995556677"],
  ["Mariana Costa",            "67890123456",    "mariana@email.com",        "11996667788"],
  ["Roberto Almeida",          "78901234567",    "roberto@email.com",        "11997778899"],
  ["Leticia Moraes",           "89012345678",    "leticia@email.com",        "11998889900"],
  ["Tech Solutions Ltda",      "11222333000181", "compras@techsol.com",      "11940001111"],
  ["Escola InfoMaster",        "22333444000192", "ti@infomaster.edu",        "11940002222"],
  ["Studio Criativo ME",       "33444555000183", "financeiro@studiocria.com","11940003333"],
  ["Construtora Vega Ltda",    "44555666000174", "ti@construtora-vega.com",  "11940004444"],
  ["Clínica Saúde Plena",      "55666777000165", "recepcao@saudeplena.com",  "11940005555"],
  ["Colégio Futuro Brilhante", "66777888000156", "informatica@cfb.edu.br",   "11940006666"],
  ["Advocacia Silva & Assoc.", "77888999000147", "adm@silvaassoc.adv.br",    "11940007777"],
]

clientes = clientes_spec.map do |nome, cpf, email, tel|
  Cliente.find_or_create_by!(cpf_cnpj: cpf) { |c| c.nome_razao_social = nome; c.email = email; c.telefone = tel }
end
puts "  ✓ #{clientes.size} clientes"

# =============================================================================
puts "\n=== Orçamentos ==="
# =============================================================================

[
  { cliente: clientes[8],  func: patricia, dias: 8,  val: 20.days.from_now,
    linhas: [[itens[1],5,869.00],[itens[7],5,719.00],[itens[11],10,159.00]] },
  { cliente: clientes[9],  func: ana,      dias: 5,  val: 25.days.from_now,
    linhas: [[itens[4],10,779.00],[itens[8],10,1149.00],[itens[18],10,259.00]] },
  { cliente: clientes[0],  func: marcos,   dias: 2,  val: 3.days.from_now,
    linhas: [[itens[19],1,449.00],[itens[14],1,319.00],[itens[23],1,349.00]] },
  { cliente: clientes[13], func: camila,   dias: 12, val: 18.days.from_now,
    linhas: [[itens[27],20,219.00],[itens[28],20,119.00],[itens[35],10,209.00]] },
  { cliente: clientes[11], func: lucas,    dias: 3,  val: 27.days.from_now,
    linhas: [[itens[15],2,2199.00],[itens[1],2,869.00],[itens[12],4,289.00]] },
].each do |od|
  orc = Orcamento.new(cliente: od[:cliente], funcionario: od[:func],
                      data_orcamento: od[:dias].days.ago, data_validade: od[:val])
  od[:linhas].each { |item, qtd, preco| orc.itens_orcamento.build(item: item, quantidade: qtd, preco_unitario: preco) }
  orc.save!
end
puts "  ✓ 5 orçamentos"

# =============================================================================
puts "\n=== Compras (14 meses, reposição de estoque) ==="
# =============================================================================
# Margem média dos itens: ~40%. Compras devem ficar em ~60-65% do faturamento.

compras_spec = [
  # Mês 11 atrás — abertura de estoque (dentro da janela de 12 meses)
  { forn: :tech,  dias: 320, venc: 290.days.from_now, status: :pago,
    linhas: [[itens[0],8,380.00],[itens[1],8,620.00],[itens[4],7,560.00],[itens[11],20,105.00],[itens[12],15,195.00]] },
  { forn: :atac,  dias: 315, venc: 285.days.from_now, status: :pago,
    linhas: [[itens[7],7,500.00],[itens[8],10,820.00],[itens[18],16,175.00],[itens[21],12,185.00]] },
  { forn: :prime, dias: 310, venc: 280.days.from_now, status: :pago,
    linhas: [[itens[15],4,1600.00],[itens[16],2,2400.00],[itens[37],3,2800.00]] },
  # Mês 9 atrás — reposição processadores e RAM
  { forn: :tech,  dias: 270, venc: 60.days.from_now, status: :pago,
    linhas: [[itens[0],5,370.00],[itens[1],6,605.00],[itens[5],3,875.00],[itens[11],12,102.00],[itens[13],8,212.00]] },
  { forn: :mega,  dias: 265, venc: 55.days.from_now, status: :pago,
    linhas: [[itens[9],20,740.00],[itens[10],5,670.00],[itens[20],8,272.00],[itens[25],6,178.00]] },
  # Mês 7 atrás — reposição placas de vídeo e monitores
  { forn: :prime, dias: 210, venc: 45.days.from_now, status: :pago,
    linhas: [[itens[15],3,1580.00],[itens[17],2,1185.00],[itens[27],4,675.00],[itens[28],3,1085.00]] },
  { forn: :global,dias: 205, venc: 40.days.from_now, status: :pago,
    linhas: [[itens[16],2,2350.00],[itens[28],2,1090.00],[itens[29],4,710.00]] },
  # Mês 5 atrás — reposição geral
  { forn: :tech,  dias: 152, venc: 30.days.from_now, status: :pago,
    linhas: [[itens[1],5,608.00],[itens[4],4,548.00],[itens[11],12,103.00],[itens[12],8,191.00],[itens[23],5,235.00]] },
  { forn: :atac,  dias: 148, venc: 28.days.from_now, status: :pago,
    linhas: [[itens[18],10,172.00],[itens[19],7,305.00],[itens[30],50,145.00],[itens[34],10,142.00],[itens[31],40,73.00]] },
  # Mês 3-4 atrás — reposição periféricos e rede
  { forn: :mega,  dias: 100, venc: 20.days.from_now, status: :pago,
    linhas: [[itens[34],8,137.00],[itens[35],5,275.00],[itens[36],8,128.00]] },
  { forn: :global,dias: 96,  venc: 18.days.from_now, status: :pago,
    linhas: [[itens[34],10,142.00],[itens[31],35,73.00],[itens[33],4,375.00]] },
  # Mês 2 atrás — reposição armazenamento e fontes
  { forn: :tech,  dias: 62,  venc: 28.days.from_now, status: :pago,
    linhas: [[itens[0],5,372.00],[itens[5],3,878.00],[itens[11],10,103.00],[itens[24],4,237.00]] },
  { forn: :atac,  dias: 58,  venc: 22.days.from_now, status: :pago,
    linhas: [[itens[18],8,170.00],[itens[21],7,182.00],[itens[22],4,254.00],[itens[34],7,141.00]] },
  # Mês passado
  { forn: :prime, dias: 35,  venc: 25.days.from_now, status: :pago,
    linhas: [[itens[15],2,1570.00],[itens[38],2,2780.00],[itens[2],3,1140.00]] },
  { forn: :mega,  dias: 28,  venc: 32.days.from_now, status: :pago,
    linhas: [[itens[9],4,735.00],[itens[25],4,482.00],[itens[26],3,375.00]] },
  # Últimas 3 semanas — reposição para o período recente
  { forn: :tech,  dias: 22,  venc: 42.days.from_now, status: :pago,
    linhas: [[itens[1],4,610.00],[itens[4],4,552.00],[itens[12],7,193.00],[itens[13],5,213.00]] },
  { forn: :global,dias: 20,  venc: 40.days.from_now, status: :pago,
    linhas: [[itens[16],1,2350.00],[itens[15],2,1570.00],[itens[28],2,1085.00],[itens[29],3,710.00]] },
  { forn: :atac,  dias: 18,  venc: 38.days.from_now, status: :pago,
    linhas: [[itens[18],8,170.00],[itens[30],12,145.00],[itens[31],12,73.00],[itens[21],5,182.00]] },
  # Pendentes — aguardando pagamento
  { forn: :global,dias: 12,  venc: 38.days.from_now, status: :pendente,
    linhas: [[itens[16],2,2380.00],[itens[29],3,1095.00],[itens[30],4,714.00]] },
  { forn: :atac,  dias: 7,   venc: 23.days.from_now, status: :pendente,
    linhas: [[itens[18],8,171.00],[itens[21],6,183.00],[itens[31],10,143.00],[itens[32],12,74.00]] },
  { forn: :prime, dias: 3,   venc: 17.days.from_now, status: :pendente,
    linhas: [[itens[37],2,2790.00],[itens[38],1,3880.00]] },
]

compras_spec.each do |cd|
  valor_total = cd[:linhas].sum { |item, qtd, preco| qtd * preco }
  compra = Compra.new(fornecedor: forns[cd[:forn]], data_vencimento: cd[:venc],
                      valor_total: valor_total, status: cd[:status])
  cd[:linhas].each { |item, qtd, preco| compra.itens_compra.build(item: item, quantidade: qtd, preco_unitario: preco) }
  compra.save!

  data_ts = cd[:dias].days.ago
  compra.update_columns(created_at: data_ts, updated_at: data_ts)

  if cd[:status] == :pago
    cd[:linhas].each do |item, qtd, _preco|
      item.increment!(:quantidade_estoque, qtd)
      MovimentacaoEstoque.create!(item: item, compra: compra, funcionario: diego,
        quantidade: qtd, tipo: :entrada, motivo: "reposição de estoque",
        data: cd[:dias].days.ago.to_date)
    end
  end
end
puts "  ✓ #{compras_spec.size} compras"

# =============================================================================
puts "\n=== Vendas (14 meses, boa margem de lucro) ==="
# =============================================================================
# Meta: receita ~1.6x o custo de compras → margem ~35-40%

vendas_spec = [
  # ── 13-14 meses atrás ────────────────────────────────────────────────────
  { cli: 8,  func: patricia, dias: 400, linhas: [[itens[1],2,869.00],[itens[7],2,719.00],[itens[11],4,159.00]] },
  { cli: 9,  func: ana,      dias: 395, linhas: [[itens[4],3,779.00],[itens[18],3,259.00],[itens[21],3,269.00]] },
  { cli: 0,  func: marcos,   dias: 390, linhas: [[itens[0],2,549.00],[itens[11],2,159.00]] },
  # itens[30]=Teclado(219) itens[31]=Mouse(119) itens[32]=Headset(189) itens[34]=Switch(209) itens[35]=Roteador(399)
  { cli: 13, func: patricia, dias: 385, linhas: [[itens[30],10,219.00],[itens[31],10,119.00]] },
  { cli: 1,  func: ana,      dias: 378, linhas: [[itens[15],1,2199.00],[itens[1],1,869.00]] },
  { cli: 10, func: marcos,   dias: 370, linhas: [[itens[18],5,259.00],[itens[19],2,449.00]] },
  { cli: 2,  func: patricia, dias: 362, linhas: [[itens[2],1,1599.00],[itens[8],1,1149.00],[itens[12],2,289.00]] },
  { cli: 11, func: ana,      dias: 355, linhas: [[itens[31],5,119.00],[itens[30],5,219.00],[itens[34],2,209.00]] },
  # ── 11-12 meses atrás ────────────────────────────────────────────────────
  { cli: 9,  func: patricia, dias: 340, linhas: [[itens[4],5,779.00],[itens[7],5,719.00],[itens[11],10,159.00],[itens[18],5,259.00]] },
  { cli: 12, func: marcos,   dias: 335, linhas: [[itens[1],1,869.00],[itens[23],1,349.00]] },
  { cli: 3,  func: ana,      dias: 328, linhas: [[itens[19],2,449.00],[itens[14],2,319.00]] },
  { cli: 0,  func: marcos,   dias: 320, linhas: [[itens[30],1,219.00],[itens[31],1,119.00],[itens[32],1,189.00]] },
  { cli: 8,  func: patricia, dias: 312, linhas: [[itens[9],3,1149.00],[itens[12],6,289.00],[itens[20],3,399.00]] },
  { cli: 14, func: ana,      dias: 305, linhas: [[itens[34],3,209.00],[itens[35],2,399.00]] },
  { cli: 5,  func: marcos,   dias: 298, linhas: [[itens[5],1,1249.00],[itens[8],1,1149.00]] },
  # ── 9-10 meses atrás ─────────────────────────────────────────────────────
  { cli: 10, func: patricia, dias: 285, linhas: [[itens[15],1,2199.00],[itens[7],1,719.00],[itens[18],1,259.00]] },
  { cli: 9,  func: ana,      dias: 278, linhas: [[itens[4],8,779.00],[itens[9],8,1149.00],[itens[18],8,259.00],[itens[21],8,269.00]] },
  { cli: 1,  func: marcos,   dias: 271, linhas: [[itens[0],1,549.00],[itens[11],2,159.00],[itens[23],1,349.00]] },
  { cli: 6,  func: patricia, dias: 265, linhas: [[itens[31],1,119.00],[itens[30],1,219.00],[itens[32],1,189.00]] },
  { cli: 11, func: ana,      dias: 258, linhas: [[itens[16],1,3299.00],[itens[1],1,869.00],[itens[12],2,289.00]] },
  { cli: 13, func: marcos,   dias: 250, linhas: [[itens[30],15,219.00],[itens[31],20,119.00],[itens[34],5,209.00]] },
  { cli: 2,  func: patricia, dias: 243, linhas: [[itens[19],1,449.00],[itens[18],1,259.00]] },
  { cli: 7,  func: ana,      dias: 237, linhas: [[itens[1],1,869.00],[itens[11],2,159.00]] },
  # ── 7-8 meses atrás ──────────────────────────────────────────────────────
  { cli: 8,  func: patricia, dias: 225, linhas: [[itens[9],5,1149.00],[itens[10],5,959.00],[itens[12],10,289.00],[itens[18],10,259.00]] },
  { cli: 3,  func: marcos,   dias: 218, linhas: [[itens[30],2,219.00],[itens[31],2,119.00]] },
  { cli: 9,  func: ana,      dias: 212, linhas: [[itens[4],4,779.00],[itens[7],4,719.00],[itens[12],8,289.00]] },
  { cli: 12, func: patricia, dias: 205, linhas: [[itens[15],1,2199.00],[itens[18],2,259.00]] },
  { cli: 4,  func: marcos,   dias: 198, linhas: [[itens[27],1,979.00],[itens[34],1,209.00]] },
  { cli: 0,  func: ana,      dias: 192, linhas: [[itens[5],1,1249.00],[itens[8],1,1149.00],[itens[12],2,289.00]] },
  { cli: 14, func: patricia, dias: 185, linhas: [[itens[34],5,209.00],[itens[35],2,399.00]] },
  { cli: 6,  func: marcos,   dias: 178, linhas: [[itens[37],1,3799.00]] },
  # ── 5-6 meses atrás ──────────────────────────────────────────────────────
  { cli: 9,  func: patricia, dias: 168, linhas: [[itens[4],6,779.00],[itens[9],6,1149.00],[itens[12],12,289.00],[itens[18],12,259.00]] },
  { cli: 10, func: camila,   dias: 162, linhas: [[itens[16],1,3299.00],[itens[1],1,869.00]] },
  { cli: 1,  func: marcos,   dias: 155, linhas: [[itens[19],2,449.00],[itens[21],2,269.00]] },
  { cli: 11, func: ana,      dias: 149, linhas: [[itens[30],8,219.00],[itens[31],10,119.00]] },
  { cli: 5,  func: camila,   dias: 142, linhas: [[itens[1],1,869.00],[itens[7],1,719.00],[itens[11],2,159.00]] },
  { cli: 8,  func: patricia, dias: 136, linhas: [[itens[15],1,2199.00],[itens[1],2,869.00],[itens[12],4,289.00]] },
  { cli: 13, func: marcos,   dias: 129, linhas: [[itens[30],20,219.00],[itens[31],20,119.00],[itens[32],10,189.00]] },
  { cli: 2,  func: camila,   dias: 123, linhas: [[itens[0],1,549.00],[itens[11],2,159.00]] },
  # ── 3-4 meses atrás ──────────────────────────────────────────────────────
  { cli: 12, func: patricia, dias: 112, linhas: [[itens[17],1,1699.00],[itens[1],1,869.00],[itens[18],1,259.00]] },
  { cli: 9,  func: camila,   dias: 105, linhas: [[itens[4],4,779.00],[itens[8],4,1149.00],[itens[18],8,259.00],[itens[21],4,269.00]] },
  { cli: 3,  func: lucas,    dias: 99,  linhas: [[itens[38],1,5299.00]] },
  { cli: 0,  func: ana,      dias: 93,  linhas: [[itens[30],1,219.00],[itens[31],1,119.00],[itens[32],1,189.00]] },
  { cli: 14, func: camila,   dias: 87,  linhas: [[itens[34],3,209.00],[itens[35],3,399.00]] },
  { cli: 7,  func: marcos,   dias: 81,  linhas: [[itens[27],1,979.00],[itens[29],1,1029.00]] },
  { cli: 6,  func: patricia, dias: 75,  linhas: [[itens[15],1,2199.00],[itens[19],2,449.00]] },
  { cli: 11, func: lucas,    dias: 68,  linhas: [[itens[30],5,219.00],[itens[31],8,119.00],[itens[35],2,399.00]] },
  # ── Último mês e meio ─────────────────────────────────────────────────────
  { cli: 8,  func: camila,   dias: 42,  linhas: [[itens[9],4,1149.00],[itens[7],4,719.00],[itens[12],8,289.00],[itens[18],8,259.00]] },
  { cli: 4,  func: ana,      dias: 38,  linhas: [[itens[30],1,219.00],[itens[31],1,119.00]] },
  { cli: 10, func: patricia, dias: 35,  linhas: [[itens[16],1,3299.00],[itens[19],1,449.00]] },
  { cli: 1,  func: lucas,    dias: 32,  linhas: [[itens[1],1,869.00],[itens[11],2,159.00],[itens[23],1,349.00]] },
  { cli: 9,  func: camila,   dias: 28,  linhas: [[itens[4],5,779.00],[itens[8],5,1149.00],[itens[18],10,259.00]] },
  { cli: 13, func: marcos,   dias: 25,  linhas: [[itens[30],12,219.00],[itens[31],15,119.00],[itens[32],5,189.00]] },
  { cli: 5,  func: ana,      dias: 22,  linhas: [[itens[38],1,5299.00]] },
  { cli: 2,  func: lucas,    dias: 19,  linhas: [[itens[0],1,549.00],[itens[7],1,719.00],[itens[12],2,289.00]] },
  { cli: 11, func: camila,   dias: 16,  linhas: [[itens[15],1,2199.00],[itens[1],1,869.00]] },
  { cli: 0,  func: patricia, dias: 13,  linhas: [[itens[30],2,219.00],[itens[31],2,119.00],[itens[35],1,399.00]] },
  { cli: 12, func: lucas,    dias: 10,  linhas: [[itens[17],1,1699.00],[itens[18],2,259.00]] },
  { cli: 3,  func: ana,      dias: 8,   linhas: [[itens[5],1,1249.00],[itens[12],2,289.00]] },
  { cli: 14, func: camila,   dias: 6,   linhas: [[itens[34],4,209.00],[itens[35],1,399.00]] },
  { cli: 6,  func: marcos,   dias: 5,   linhas: [[itens[27],1,979.00],[itens[31],1,119.00]] },
  { cli: 8,  func: patricia, dias: 4,   linhas: [[itens[9],3,1149.00],[itens[10],3,959.00],[itens[18],6,259.00]] },
  { cli: 7,  func: lucas,    dias: 3,   linhas: [[itens[37],1,3799.00]] },
  { cli: 4,  func: ana,      dias: 2,   linhas: [[itens[19],1,449.00],[itens[11],2,159.00]] },
  { cli: 1,  func: camila,   dias: 1,   linhas: [[itens[16],1,3299.00],[itens[19],1,449.00]] },
]

vendas_spec.each do |vd|
  data = vd[:dias].days.ago.to_date
  venda = Venda.new(
    cliente: clientes[vd[:cli]], funcionario: vd[:func],
    data_venda: data,
    valor_total: vd[:linhas].sum { |item, qtd, preco| qtd * preco }
  )
  vd[:linhas].each { |item, qtd, preco| venda.itens_venda.build(item: item, quantidade: qtd, preco_unitario: preco) }

  unless venda.save
    puts "\n❌ Erro na venda (cli: #{vd[:cli]}, dias_atras: #{vd[:dias]}):"
    venda.itens_venda.each do |iv|
      next unless iv.errors.any?
      puts "  → #{iv.item&.descricao}: #{iv.errors.full_messages.join(', ')} (estoque atual: #{iv.item&.quantidade_estoque})"
    end
    puts "  Venda: #{venda.errors.full_messages.join(', ')}" if venda.errors.any?
    raise "Corrija os dados em exemplos.rb e tente novamente."
  end

  vd[:linhas].each do |item, qtd, _|
    item.decrement!(:quantidade_estoque, qtd)
    MovimentacaoEstoque.create!(item: item, venda: venda, funcionario: admin,
      quantidade: qtd, tipo: :saida, motivo: "item vendido", data: data)
  end
end
puts "  ✓ #{vendas_spec.size} vendas"

# =============================================================================
receita = Venda.sum(:valor_total)
custo   = Compra.where(status: :pago).sum(:valor_total)
margem  = custo > 0 ? ((receita - custo) / receita * 100).round(1) : 0

# =============================================================================
puts "\n=== Vendas extras — drenando itens de alta demanda ==="
# =============================================================================
# Vende os itens que iniciaram com estoque baixo para zerá-los naturalmente

vendas_dreno = [
  { cli: 5,  func: fernando, dias: 360, linhas: [[itens[3],1,2899.00]] },
  { cli: 11, func: patricia, dias: 310, linhas: [[itens[3],1,2899.00],[itens[6],1,1999.00]] },
  { cli: 8,  func: camila,   dias: 260, linhas: [[itens[3],1,2899.00],[itens[16],1,3299.00]] },
  { cli: 6,  func: marcos,   dias: 210, linhas: [[itens[6],1,1999.00],[itens[16],1,3299.00]] },
  { cli: 14, func: patricia, dias: 160, linhas: [[itens[3],1,2899.00],[itens[38],1,5299.00]] },
  { cli: 5,  func: ana,      dias: 110, linhas: [[itens[6],1,1999.00],[itens[38],1,5299.00]] },
  { cli: 10, func: camila,   dias: 60,  linhas: [[itens[38],1,5299.00]] },
]

vendas_dreno.each do |vd|
  data = vd[:dias].days.ago.to_date
  venda = Venda.new(
    cliente: clientes[vd[:cli]], funcionario: vd[:func],
    data_venda: data,
    valor_total: vd[:linhas].sum { |item, qtd, preco| qtd * preco }
  )
  vd[:linhas].each { |item, qtd, preco| venda.itens_venda.build(item: item, quantidade: qtd, preco_unitario: preco) }

  unless venda.save
    puts "\n❌ Erro na venda dreno (cli: #{vd[:cli]}, dias_atras: #{vd[:dias]}):"
    venda.itens_venda.each do |iv|
      next unless iv.errors.any?
      puts "  → #{iv.item&.descricao}: #{iv.errors.full_messages.join(', ')} (estoque atual: #{iv.item&.quantidade_estoque})"
    end
    raise "Corrija os dados em exemplos.rb e tente novamente."
  end
  vd[:linhas].each do |item, qtd, _|
    item.decrement!(:quantidade_estoque, qtd)
    MovimentacaoEstoque.create!(item: item, venda: venda, funcionario: admin,
      quantidade: qtd, tipo: :saida, motivo: "item vendido", data: data)
  end
end
puts "  ✓ #{vendas_dreno.size} vendas extras registradas"

# =============================================================================
puts "\n=== Movimentações manuais de correção de inventário ==="
# =============================================================================
# Simulam contagens físicas periódicas com divergências registradas

correcoes = [
  # Entradas — contagem encontrou mais unidades do que o sistema registrava
  { item: itens[21], tipo: :entrada, qtd: 2, motivo: "correção de inventário — 2 unidades encontradas sem registro",          func: renata, dias: 320 },
  { item: itens[31], tipo: :entrada, qtd: 3, motivo: "correção de inventário — unidades localizadas em prateleira incorreta", func: renata, dias: 190 },
  { item: itens[36], tipo: :entrada, qtd: 1, motivo: "correção de inventário — unidade retornada de exposição sem baixa",     func: renata, dias: 95  },
  # Saídas — contagem encontrou menos unidades do que o sistema registrava
  { item: itens[15], tipo: :saida,   qtd: 3, motivo: "correção de inventário — 3 unidades com defeito retiradas do estoque",  func: renata, dias: 280 },
  { item: itens[33], tipo: :saida,   qtd: 2, motivo: "correção de inventário — divergência após contagem física",             func: renata, dias: 200 },
  { item: itens[27], tipo: :saida,   qtd: 3, motivo: "correção de inventário — monitores danificados no transporte",          func: renata, dias: 140 },
  { item: itens[17], tipo: :saida,   qtd: 4, motivo: "correção de inventário — unidades com defeito de fábrica devolvidas",   func: renata, dias: 85  },
  { item: itens[24], tipo: :saida,   qtd: 2, motivo: "correção de inventário — fontes retiradas para uso interno",            func: diego,  dias: 50  },
  { item: itens[26], tipo: :saida,   qtd: 3, motivo: "correção de inventário — divergência após auditoria trimestral",        func: renata, dias: 20  },
  { item: itens[8],  tipo: :saida,   qtd: 4, motivo: "correção de inventário — placas com chipset danificado identificadas",  func: renata, dias: 10  },
]

correcoes.each do |c|
  data = c[:dias].days.ago.to_date
  if c[:tipo] == :saida
    c[:item].decrement!(:quantidade_estoque, c[:qtd])
  else
    c[:item].increment!(:quantidade_estoque, c[:qtd])
  end
  MovimentacaoEstoque.create!(
    item:        c[:item],
    funcionario: c[:func],
    quantidade:  c[:qtd],
    tipo:        c[:tipo],
    motivo:      c[:motivo],
    data:        data
  )
  dir = c[:tipo] == :saida ? "-#{c[:qtd]}" : "+#{c[:qtd]}"
  puts "  ✓ #{c[:item].descricao[0..34].ljust(35)} #{dir.rjust(4)} | #{c[:motivo][0..45]}"
end

puts "\n✅ Dados de exemplo inseridos com sucesso!"
puts "   #{funcionarios_data.size} funcionários | #{clientes.size} clientes | #{itens.size} itens"
puts "   #{Orcamento.count} orçamentos | #{Venda.count} vendas | #{Compra.count} compras"
puts "\n   Resumo financeiro (acumulado):"
puts "   Receita : R$ #{format('%.2f', receita)}"
puts "   Custo   : R$ #{format('%.2f', custo)}"
puts "   Margem  : #{margem}%"
puts "\n   Logins: ana / marcos / patricia / camila / lucas @sigie.com (senha: senha123456)"
