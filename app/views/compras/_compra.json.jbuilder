json.extract! compra, :id, :fornecedor_id, :item_id, :descricao, :valor_total, :data_vencimento, :status, :created_at, :updated_at
json.url compra_url(compra, format: :json)
