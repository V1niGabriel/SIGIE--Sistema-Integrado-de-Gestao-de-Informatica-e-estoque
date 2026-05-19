module DashboardHelper
  def periodo_label
    case @periodo
    when "semana" then "Últimos 7 dias"
    when "ano"    then "Últimos 12 meses"
    else               "Últimos 30 dias"
    end
  end
end
