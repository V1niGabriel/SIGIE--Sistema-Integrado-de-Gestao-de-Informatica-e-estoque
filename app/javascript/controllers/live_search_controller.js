import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // Adicionamos o "criteria" (critério/filtro) aos nossos alvos
  static targets = ["input", "criteria", "row"]

  filter() {
    const query = this.inputTarget.value.toLowerCase()
    const criteria = this.criteriaTarget.value // Lê o que está selecionado (todos, descricao, categoria...)

    this.rowTargets.forEach(row => {
      let match = false

      // Se escolheu "Todos", pesquisa nos três campos (Descrição, Categoria ou Fabricante)
      if (criteria === "todos") {
        const desc = row.dataset.descricao || ""
        const cat = row.dataset.categoria || ""
        const fab = row.dataset.fabricante || ""
        match = desc.includes(query) || cat.includes(query) || fab.includes(query)
      } 
      // Se escolheu um específico, pesquisa só nele!
      else {
        const textToSearch = row.dataset[criteria] || ""
        match = textToSearch.includes(query)
      }

      // Mostra ou esconde a linha dependendo do resultado
      if (match) {
        row.style.display = ""
      } else {
        row.style.display = "none"
      }
    })
  }
}