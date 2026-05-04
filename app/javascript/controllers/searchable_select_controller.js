import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["hiddenInput", "searchInput", "list", "option"]

  // Quando clica no campo de texto, mostra a lista
  show() {
    this.listTarget.style.display = "block"
    this.filter() // Já filtra caso tenha algo digitado
  }

  // Quando clica fora do campo, esconde a lista
  hide() {
    // O setTimeout é um truque essencial: ele espera uma fração de segundo antes de fechar,
    // garantindo que o navegador tenha tempo de registrar o clique no item da lista.
    setTimeout(() => {
      this.listTarget.style.display = "none"
    }, 150)
  }

  // A mágica da busca conforme digita
  filter() {
    const term = this.searchInputTarget.value.toLowerCase()

    this.optionTargets.forEach(el => {
      const text = el.dataset.text
      if (text.includes(term)) {
        el.classList.remove("hidden") // Mostra se bater com a busca
      } else {
        el.classList.add("hidden")    // Esconde se não bater
      }
    })
  }

  // Quando clica em um item da lista
  select(event) {
    const el = event.currentTarget
    
    // 1. Atualiza o input escondido com o ID real (que vai pro banco de dados)
    this.hiddenInputTarget.value = el.dataset.value
    
    // 2. Atualiza o campo de texto visual com o nome do cliente escolhido
    this.searchInputTarget.value = el.innerText
    
    // 3. Esconde a lista flutuante
    this.listTarget.style.display = "none"

    // 4. Grita para o sistema que o valor mudou (Isso acorda o venda_controller para liberar o botão de orçamento!)
    this.hiddenInputTarget.dispatchEvent(new Event("change", { bubbles: true }))
  }
}