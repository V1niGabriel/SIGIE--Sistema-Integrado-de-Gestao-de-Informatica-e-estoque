json.extract! funcionario, :id, :cargo_id, :nome, :cpf, :email, :telefone, :data_admissao, :senha_hash, :created_at, :updated_at
json.url funcionario_url(funcionario, format: :json)
