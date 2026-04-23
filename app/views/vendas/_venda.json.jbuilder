json.extract! venda, :id, :cliente_id, :funcionario_id, :data_venda, :status_pagamento, :created_at, :updated_at
json.url venda_url(venda, format: :json)
