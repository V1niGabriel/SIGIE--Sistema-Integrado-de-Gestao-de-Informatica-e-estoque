class Venda < ApplicationRecord
  belongs_to :cliente
  belongs_to :funcionario

  # 1. Lembra da tabela ItensVenda? Aqui nós conectamos as duas!
  # O class_name garante que ele ache o Model correto, e o accepts_nested_attributes_for
  # permite salvar tudo junto na mesma tela de Venda.
  has_many :itens_venda, class_name: "ItemVenda", dependent: :destroy
  accepts_nested_attributes_for :itens_venda, allow_destroy: true

  # 2. Dica de Ouro: Enum para o status de pagamento!
  # Como no banco o status_pagamento é um número (integer) com default 0,
  # você pode mapear palavras para esses números. O Rails converte automaticamente.
  enum :status_pagamento, { pendente: 0, pago: 1, cancelado: 2 }
end
