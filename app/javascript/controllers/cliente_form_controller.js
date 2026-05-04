import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tipo", "documentoLabel", "documentoInput", "erro"]

  connect() {
    this.toggleTipo() // Ajusta os campos assim que a página carrega
  }

  // Alterna entre CPF e CNPJ
  toggleTipo() {
    const tipo = this.tipoTarget.value
    const input = this.documentoInputTarget
    const label = this.documentoLabelTarget
    
    this.esconderErro()

    if (tipo === "pf") {
      label.textContent = "CPF (Opcional)"
      input.placeholder = "Ex: 123.456.789-00"
      input.maxLength = 14
      input.required = false
    } else {
      label.textContent = "CNPJ (Obrigatório)"
      input.placeholder = "Ex: 12.345.678/0001-90"
      input.maxLength = 18
      input.required = true
    }
  }

  // Aplica a máscara enquanto o usuário digita
  formatarDocumento(event) {
    let v = event.target.value.replace(/\D/g, "")
    const tipo = this.tipoTarget.value

    this.esconderErro()

    if (tipo === "pf") {
      if (v.length > 11) v = v.slice(0, 11)
      v = v.replace(/(\d{3})(\d)/, "$1.$2")
      v = v.replace(/(\d{3})(\d)/, "$1.$2")
      v = v.replace(/(\d{3})(\d{1,2})$/, "$1-$2")
    } else {
      if (v.length > 14) v = v.slice(0, 14)
      v = v.replace(/^(\d{2})(\d)/, "$1.$2")
      v = v.replace(/^(\d{2})\.(\d{3})(\d)/, "$1.$2.$3")
      v = v.replace(/\.(\d{3})(\d)/, ".$1/$2")
      v = v.replace(/(\d{4})(\d)/, "$1-$2")
    }

    event.target.value = v
  }

  // Valida quando o usuário tira o mouse do campo (blur)
  validarDocumento() {
    const tipo = this.tipoTarget.value
    const valorPuro = this.documentoInputTarget.value.replace(/\D/g, "")
    const input = this.documentoInputTarget

    if (tipo === "pf" && valorPuro.length > 0) {
      if (!this.validaCPF(valorPuro)) {
        this.mostrarErro("CPF inválido. Verifique a digitação.")
        input.setCustomValidity("CPF inválido.") // Isso bloqueia o envio do formulário!
      }
    } else if (tipo === "pj" && valorPuro.length > 0) {
      if (valorPuro.length !== 14) {
        this.mostrarErro("CNPJ incompleto.")
        input.setCustomValidity("CNPJ incompleto.") // Isso bloqueia o envio
      }
    }
  }

  mostrarErro(mensagem) {
    this.erroTarget.textContent = mensagem
    this.erroTarget.style.display = "block"
  }

  esconderErro() {
    this.erroTarget.style.display = "none"
    this.documentoInputTarget.setCustomValidity("") // Libera o envio do formulário
  }

  // Algoritmo matemático real para validar CPF
  validaCPF(cpf) {
    if (cpf.length !== 11 || /^(\d)\1{10}$/.test(cpf)) return false
    
    let soma = 0, resto
    
    for (let i = 1; i <= 9; i++) soma += parseInt(cpf.substring(i-1, i)) * (11 - i)
    resto = (soma * 10) % 11
    if (resto === 10 || resto === 11) resto = 0
    if (resto !== parseInt(cpf.substring(9, 10))) return false
    
    soma = 0
    for (let i = 1; i <= 10; i++) soma += parseInt(cpf.substring(i-1, i)) * (12 - i)
    resto = (soma * 10) % 11
    if (resto === 10 || resto === 11) resto = 0
    if (resto !== parseInt(cpf.substring(10, 11))) return false
    
    return true
  }
}