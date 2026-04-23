json.extract! item, :id, :fornecedor_id, :categoria_id, :fabricante_id, :descricao, :quantidade_estoque, :preco_custo, :preco_venda, :ncm, :created_at, :updated_at
json.url item_url(item, format: :json)
