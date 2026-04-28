import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["itemsBody", "total", "rowTemplate", "modal", "modalClienteSelect", "modalOrcamentosContainer"]
  static values = { items: Array }

  connect() {
    this.updateTotal()
  }

  // ---- Carrinho ----

  addItem() {
    const template = this.rowTemplateTarget.content.cloneNode(true)
    const row = template.querySelector("tr")
    const index = Date.now()
    row.innerHTML = row.innerHTML.replaceAll("NEW_RECORD", index)
    this.itemsBodyTarget.appendChild(row)
  }

  removeItem(event) {
    const row = event.target.closest("tr")
    const destroyInput = row.querySelector("input[name*='_destroy']")
    if (destroyInput) {
      destroyInput.value = "1"
      row.style.display = "none"
    } else {
      row.remove()
    }
    this.updateTotal()
  }

  onItemSelect(event) {
    const select = event.target
    const itemId = select.value
    const currentRow = select.closest("tr")

    if (!itemId) return

    const existingRow = this.findRowWithItem(itemId, currentRow)
    if (existingRow) {
      const qtyInput = existingRow.querySelector("input[name*='quantidade']")
      qtyInput.value = parseInt(qtyInput.value || 1) + 1
      this.recalcRow(existingRow)
      const destroyInput = currentRow.querySelector("input[name*='_destroy']")
      if (destroyInput) {
        destroyInput.value = "1"
        currentRow.style.display = "none"
      } else {
        currentRow.remove()
      }
      this.updateTotal()
      return
    }

    const itemData = this.getItemData(itemId)
    const priceInput = currentRow.querySelector("input[name*='preco_unitario']")
    const qtyInput = currentRow.querySelector("input[name*='quantidade']")

    priceInput.value = itemData.preco.toFixed(2)
    qtyInput.max = itemData.estoque
    if (parseInt(qtyInput.value) > itemData.estoque) qtyInput.value = itemData.estoque

    this.recalcRow(currentRow)
  }

  updateSubtotal(event) {
    this.recalcRow(event.target.closest("tr"))
  }

  // ---- Modal de orçamentos ----

  openModal() {
    this.modalTarget.style.display = "flex"
    this.modalOrcamentosContainerTarget.innerHTML = ""
    this.modalClienteSelectTarget.value = ""
  }

  closeModal() {
    this.modalTarget.style.display = "none"
  }

  closeModalOnBackdrop(event) {
    if (event.target === this.modalTarget) this.closeModal()
  }

  async onModalClienteChange(event) {
    const clienteId = event.target.value
    const container = this.modalOrcamentosContainerTarget

    if (!clienteId) {
      container.innerHTML = ""
      return
    }

    container.innerHTML = '<p class="modal-loading">Buscando orçamentos...</p>'

    const resp = await fetch(`/orcamentos/por_cliente?cliente_id=${clienteId}`, {
      headers: { "Accept": "application/json" }
    })
    const orcamentos = await resp.json()

    if (orcamentos.length === 0) {
      container.innerHTML = '<p class="modal-empty">Nenhum orçamento encontrado para este cliente.</p>'
      return
    }

    container.innerHTML = orcamentos.map(o => `
      <div class="modal-orcamento-card" data-action="click->venda#loadOrcamento"
           data-orcamento='${JSON.stringify(o)}'>
        <div class="modal-orc-header">
          <span class="modal-orc-id">Orçamento #${o.id}</span>
          <span class="modal-orc-date">${o.data} &nbsp;·&nbsp; Válido até ${o.data_validade}</span>
        </div>
        <div class="modal-orc-itens">
          ${o.itens.map(i => `<span>${i.descricao} × ${i.quantidade}</span>`).join(" &nbsp;|&nbsp; ")}
        </div>
      </div>
    `).join("")
  }

  loadOrcamento(event) {
    const card = event.currentTarget
    const orcamento = JSON.parse(card.dataset.orcamento)

    // Limpa linhas novas do carrinho (mantém registros persistidos marcando destroy)
    this.itemsBodyTarget.querySelectorAll("tr").forEach(row => {
      const destroyInput = row.querySelector("input[name*='_destroy']")
      if (destroyInput) {
        destroyInput.value = "1"
        row.style.display = "none"
      } else {
        row.remove()
      }
    })

    // Adiciona cada item do orçamento no carrinho
    orcamento.itens.forEach((item, i) => {
      const template = this.rowTemplateTarget.content.cloneNode(true)
      const row = template.querySelector("tr")
      const index = Date.now() + i
      row.innerHTML = row.innerHTML.replaceAll("NEW_RECORD", index)

      const select = row.querySelector("select[name*='item_id']")
      const qtyInput = row.querySelector("input[name*='quantidade']")
      const priceInput = row.querySelector("input[name*='preco_unitario']")

      const itemData = this.getItemData(item.item_id)
      select.value = String(item.item_id)
      qtyInput.max = itemData.estoque
      qtyInput.value = Math.min(item.quantidade, itemData.estoque)
      priceInput.value = item.preco_unitario.toFixed(2)

      this.itemsBodyTarget.appendChild(row)
      this.recalcRow(this.itemsBodyTarget.lastElementChild)
    })

    // Preenche o select de cliente
    const clienteSelect = this.element.querySelector("select[name*='cliente_id']")
    if (clienteSelect) clienteSelect.value = orcamento.cliente_id

    this.closeModal()
  }

  // ---- Helpers ----

  recalcRow(row) {
    const qty = parseFloat(row.querySelector("input[name*='quantidade']")?.value) || 0
    const price = parseFloat(row.querySelector("input[name*='preco_unitario']")?.value) || 0
    row.querySelector(".cart-subtotal").textContent = this.formatCurrency(qty * price)
    this.updateTotal()
  }

  updateTotal() {
    let total = 0
    this.itemsBodyTarget.querySelectorAll("tr").forEach(row => {
      if (row.style.display === "none") return
      const qty = parseFloat(row.querySelector("input[name*='quantidade']")?.value) || 0
      const price = parseFloat(row.querySelector("input[name*='preco_unitario']")?.value) || 0
      total += qty * price
    })
    this.totalTarget.textContent = this.formatCurrency(total)
  }

  findRowWithItem(itemId, excludeRow) {
    let found = null
    this.itemsBodyTarget.querySelectorAll("tr").forEach(row => {
      if (row === excludeRow || row.style.display === "none") return
      const select = row.querySelector("select[name*='item_id']")
      if (select && select.value == itemId) found = row
    })
    return found
  }

  getItemData(itemId) {
    return this.itemsValue.find(i => i.id == itemId) || { preco: 0, estoque: 0 }
  }

  formatCurrency(value) {
    return value.toLocaleString("pt-BR", { style: "currency", currency: "BRL" })
  }
}
