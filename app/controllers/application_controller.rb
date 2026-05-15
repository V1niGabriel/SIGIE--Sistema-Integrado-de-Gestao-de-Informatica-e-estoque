class ApplicationController < ActionController::Base
  # Mantém as configurações originais do Rails 8
  allow_browser versions: :modern
  stale_when_importmap_changes

  # Garante que o funcionário esteja logado em qualquer página
  before_action :authenticate_funcionario!

  # Método auxiliar para checar permissão
  def verificar_permissao(permissao)
    # Se o funcionário não tiver a permissão no cargo...
    unless current_funcionario.cargo.send(permissao)
      
      # Verificamos se ele já está na página inicial para evitar loop infinito
      if request.path == root_path
        # Se ele tentou acessar o início e não tem permissão, mostramos uma tela amigável
        # em vez de redirecionar de novo.
        render html: "
          <div style='font-family: sans-serif; text-align: center; margin-top: 100px; color: #374151;'>
            <h2 style='color: #991b1b;'>Acesso Restrito</h2>
            <p>Seu cargo (<strong>#{current_funcionario.cargo.titulo}</strong>) não tem permissão para esta tela.</p>
            <p style='color: #6b7280;'>Por favor, utilize o menu lateral para navegar nas áreas permitidas.</p>
          </div>".html_safe, 
          layout: true, 
          status: :forbidden
      else
        # Se ele tentou acessar qualquer outra página (ex: /cargos), 
        # manda de volta para onde ele estava com um alerta.
        redirect_back(fallback_location: root_path, alert: "Você não tem permissão para acessar esta área.")
      end
      
    end
  end
end