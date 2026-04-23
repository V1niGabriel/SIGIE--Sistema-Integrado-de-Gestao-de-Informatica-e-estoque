json.extract! dados_empresa, :id, :cnpj, :razao_social, :ie, :im, :regime_tributario, :rua, :numero, :complemento, :bairro, :cidade, :estado, :cep, :created_at, :updated_at
json.url dados_empresa_url(dados_empresa, format: :json)
