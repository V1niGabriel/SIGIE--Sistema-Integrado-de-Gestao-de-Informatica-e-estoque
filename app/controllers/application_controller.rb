class ApplicationController < ActionController::Base
  # Mantém as configurações originais do Rails 8
  allow_browser versions: :modern
  stale_when_importmap_changes

  # Garante que o funcionário esteja logado em qualquer página
  before_action :authenticate_funcionario!

  def verificar_permissao(permissao)
    unless current_funcionario.cargo.send(permissao)
      redirect_back(fallback_location: root_path, alert: "Você não tem permissão para acessar esta área.")
    end
  end
end