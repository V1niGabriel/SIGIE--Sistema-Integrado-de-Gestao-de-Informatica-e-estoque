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

puts "Configuração de ambiente concluída! 🌱"