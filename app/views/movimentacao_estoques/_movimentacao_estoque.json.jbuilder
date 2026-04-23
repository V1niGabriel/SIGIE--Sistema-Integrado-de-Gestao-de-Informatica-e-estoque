json.extract! movimentacao_estoque, :id, :funcionario_id, :item_id, :venda_id, :compra_id, :tipo, :quantidade, :motivo, :data, :created_at, :updated_at
json.url movimentacao_estoque_url(movimentacao_estoque, format: :json)
