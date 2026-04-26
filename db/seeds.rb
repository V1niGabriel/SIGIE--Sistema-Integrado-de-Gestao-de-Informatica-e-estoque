#Cria os dados iniciais básicos para acessar o sistema 

puts "Criando cargo de Administrador..."
cargo_admin = Cargo.find_or_create_by!(titulo: "Administrador") do |cargo|
  cargo.descricao = "Acesso total ao sistema"
  cargo.salario_base = 5000.00
end

puts "Criando usuário Master..."
Funcionario.find_or_create_by!(email: "admin@sigie.com") do |func|
  func.nome = "Admin Principal"
  func.password = "senhasegura123"
  func.password_confirmation = "senhasegura123"
  func.cpf = "11122233344"
  func.telefone = "11999999999"
  func.data_admissao = Time.current
  func.cargo = cargo_admin
end

# ... código do administrador anterior ...

puts "Criando Categorias..."
Categoria.find_or_create_by!(nome_categoria: "Processadores")
Categoria.find_or_create_by!(nome_categoria: "Placas Mãe")
Categoria.find_or_create_by!(nome_categoria: "Memórias RAM")
Categoria.find_or_create_by!(nome_categoria: "Periféricos")

puts "Criando Fabricantes..."
Fabricante.find_or_create_by!(nome_marca: "Intel")
Fabricante.find_or_create_by!(nome_marca: "AMD")
Fabricante.find_or_create_by!(nome_marca: "Asus")
Fabricante.find_or_create_by!(nome_marca: "Kingston")

puts "Criando Fornecedores..."
Fornecedor.find_or_create_by!(cnpj: "12345678000190") do |f|
  f.nome = "Distribuidora Tech"
  f.telefone = "11988887777"
  f.email = "contato@distribuidoratech.com.br"
end

Fornecedor.find_or_create_by!(cnpj: "98765432000110") do |f|
  f.nome = "Atacadão da Informática"
  f.telefone = "11977776666"
  f.email = "vendas@atacadaoinfo.com.br"
end

puts "Sementes adicionais plantadas com sucesso! 🚀"

puts "Configuração de ambiente concluída! 🌱"