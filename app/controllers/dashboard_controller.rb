class DashboardController < ApplicationController
  before_action :authenticate_funcionario!

  def index
    @periodo = params[:periodo] || "mes"
    @inicio  = periodo_inicio(@periodo)
    cargo    = current_funcionario.cargo

    if cargo.visualizar_vendas?
      vendas_periodo  = Venda.where(data_venda: @inicio..)
      @vendas_count   = vendas_periodo.count
      @vendas_valor   = vendas_periodo.sum(:valor_total).to_f
      @ticket_medio   = @vendas_count > 0 ? (@vendas_valor / @vendas_count).round(2) : 0
      @ultimas_vendas = Venda.includes(:cliente).order(data_venda: :desc).limit(8)

      vendas_por_data = aggregate_by_date(vendas_periodo.pluck(:data_venda, :valor_total))
      @vendas_chart_labels, @vendas_chart_values = build_date_series(@inicio, vendas_por_data, @periodo)
    end

    if cargo.visualizar_orcamentos?
      orc_periodo          = Orcamento.where(data_orcamento: @inicio..)
      @orcamentos_count    = orc_periodo.count
      @orcamentos_vencendo = Orcamento.where(data_validade: Date.current..7.days.from_now).count
      @orcamentos_vencidos = Orcamento.where("data_validade < ?", Date.current).count
      @orcamentos_recentes = orc_periodo.includes(:cliente).order(data_orcamento: :desc).limit(6)

      # Conta orçamentos por dia (value = 1.0 por ocorrência)
      orc_por_data = aggregate_by_date(orc_periodo.pluck(:data_orcamento).map { |d| [d, 1] })
      @orcamentos_chart_labels, @orcamentos_chart_values = build_date_series(@inicio, orc_por_data, @periodo)
    end

    if cargo.visualizar_itens?
      @itens_count         = Item.count
      @itens_estoque_baixo = Item.where("quantidade_estoque <= ?", 10).order(:quantidade_estoque).limit(8)
      @itens_zerados       = Item.where(quantidade_estoque: 0).count
      @valor_estoque       = Item.sum("quantidade_estoque * preco_custo").to_f
      @itens_criticos      = Item.order(:quantidade_estoque).limit(8)
    end

    if cargo.visualizar_compras?
      @compras_pendentes   = Compra.where(status: :pendente).count
      @compras_pagas       = Compra.where(status: :pago).count
      @compras_canceladas  = Compra.where(status: :cancelado).count
      @compras_recentes    = Compra.includes(:fornecedor)
                                   .where(created_at: @inicio.beginning_of_day..)
                                   .order(created_at: :desc).limit(8)
      @compras_valor_total = @compras_recentes.sum(&:valor_total).to_f
    end

    if cargo.visualizar_vendas? && cargo.visualizar_compras?
      compras_periodo  = Compra.where(created_at: @inicio.beginning_of_day.., status: :pago)
      @custo_periodo   = compras_periodo.sum(:valor_total).to_f
      @lucro_periodo   = @vendas_valor - @custo_periodo
      @margem          = @vendas_valor > 0 ? ((@lucro_periodo / @vendas_valor) * 100).round(1) : 0

      compras_por_data = aggregate_by_date(
        compras_periodo.pluck(:created_at, :valor_total).map { |ts, v| [ts.to_date, v] }
      )
      @lucro_labels  = @vendas_chart_labels
      @lucro_receita = @vendas_chart_values
      _labels, @lucro_custo = build_date_series(@inicio, compras_por_data, @periodo)

      @compras_periodo_lista = @compras_recentes
    end

    if cargo.visualizar_clientes?
      @clientes_count = Cliente.count
    end

    if cargo.visualizar_funcionarios?
      @funcionarios_count = Funcionario.count
    end
  end

  private

  def periodo_inicio(periodo)
    case periodo
    when "semana" then 6.days.ago.to_date
    when "ano"    then 11.months.ago.beginning_of_month.to_date
    else               29.days.ago.to_date
    end
  end

  # [[date_or_datetime, value], ...] → {Date => Float}
  def aggregate_by_date(pairs)
    pairs.each_with_object(Hash.new(0.0)) do |(date, value), h|
      h[date.to_date] += value.to_f
    end
  end

  # {Date => Float} → [[labels], [values]] preenchendo todos os dias/meses do período
  def build_date_series(inicio, data_hash, periodo)
    if periodo == "ano"
      keys   = (11.downto(0)).map { |i| i.months.ago.beginning_of_month.to_date }
      labels = keys.map { |d| d.strftime("%b/%y") }
      values = keys.map do |month_start|
        month_end = month_start.end_of_month
        data_hash.sum { |d, v| d.between?(month_start, month_end) ? v : 0.0 }
      end
    else
      keys   = (inicio..Date.current).to_a
      labels = keys.map { |d| d.strftime("%d/%m") }
      values = keys.map { |d| data_hash[d] || 0.0 }
    end
    [labels, values]
  end
end
