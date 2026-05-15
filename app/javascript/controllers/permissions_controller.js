import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // master: A chave principal de "Acesso Total"
  // checkbox: Todas as outras chaves da tabela
  // adminWrapper, adminText: Alvos visuais para mudarmos a cor do botão
  static targets = ["master", "checkbox", "adminWrapper", "adminText"]

  // connect() roda automaticamente assim que a página termina de carregar
  connect() {
    this.updateColors()
  }

  // Função que liga/desliga tudo quando clica no master
  toggleAll(event) {
    const isChecked = event.target.checked
    
    this.checkboxTargets.forEach(checkbox => {
      checkbox.checked = isChecked
    })
    
    // Chama a função de cor após ligar/desligar tudo
    this.updateColors()
  }

  // Função que desmarca o "Acesso Total" se o usuário desligar uma chave individualmente
  checkMaster() {
    const allChecked = this.checkboxTargets.every(checkbox => checkbox.checked)
    this.masterTarget.checked = allChecked
    
    // Chama a função de cor caso a chavinha master mude
    this.updateColors()
  }

  // A Mágica das Cores
  updateColors() {
    // Verificação de segurança: se a tela não tiver a div do botão admin, o código para aqui
    if (!this.hasAdminWrapperTarget || !this.hasAdminTextTarget) return;

    if (this.masterTarget.checked) {
      // LIGADO: Fica Verde amigável
      this.adminWrapperTarget.style.backgroundColor = '#d1fae5' // Fundo verde clarinho
      this.adminWrapperTarget.style.borderColor = '#34d399'     // Borda verde
      this.adminTextTarget.style.color = '#065f46'              // Texto verde escuro
    } else {
      // DESLIGADO: Fica Vermelho amigável
      this.adminWrapperTarget.style.backgroundColor = '#fee2e2' // Fundo vermelho clarinho
      this.adminWrapperTarget.style.borderColor = '#fca5a5'     // Borda vermelha
      this.adminTextTarget.style.color = '#991b1b'              // Texto vermelho escuro
    }
  }
}