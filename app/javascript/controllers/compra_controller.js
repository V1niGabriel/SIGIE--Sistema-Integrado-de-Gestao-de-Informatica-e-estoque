import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["itemsBody", "total", "rowTemplate", "novoItemModal", "novoItemForm", "novoItemFeedback"]
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

  // ---- Busca de item por texto ----

  filterItems(event) {
    const input = event.target
    const query = input.value.toLowerCase().trim()
    const row = input.closest("tr")
    const dropdown = row.querySelector(".item-dropdown")
    const hiddenInput = row.querySelector("input[name*='item_id']")

    hiddenInput.value = ""
    this.updateTotal()

    const filtered = query.length === 0
      ? this.itemsValue
      : this.itemsValue.filter(i => i.descricao.toLowerCase().includes(query))

    dropdown.innerHTML = filtered.map(i =>
      `<li class="item-option" data-id="${i.id}" data-descricao="${i.descricao}"
           data-preco="${i.preco_custo}" data-estoque="${i.estoque}">
        ${i.descricao}
        <span class="item-option-estoque">${i.estoque} em estoque</span>
      </li>`
    ).join("")

    dropdown.style.display = filtered.length > 0 ? "block" : "none"

    dropdown.querySelectorAll(".item-option").forEach(li => {
      li.addEventListener("mousedown", (e) => {
        e.preventDefault()
        this.selectItem(row, li)
      })
    })
  }

  selectItem(row, li) {
    const id = li.dataset.id
    const descricao = li.dataset.descricao
    const preco = parseFloat(li.dataset.preco)
    const estoque = parseInt(li.dataset.estoque)

    const searchInput = row.querySelector(".item-search-input")
    const hiddenInput = row.querySelector("input[name*='item_id']")
    const priceInput = row.querySelector("input[name*='preco_unitario']")
    const qtyInput = row.querySelector("input[name*='quantidade']")
    const dropdown = row.querySelector(".item-dropdown")

    const existingRow = this.findRowWithItem(id, row)
    if (existingRow) {
      const existingQty = existingRow.querySelector("input[name*='quantidade']")
      existingQty.value = parseInt(existingQty.value || 1) + 1
      this.recalcRow(existingRow)
      row.remove()
      this.updateTotal()
      return
    }

    searchInput.value = descricao
    hiddenInput.value = id
    priceInput.value = preco.toFixed(2)
    qtyInput.min = 1
    qtyInput.max = ""
    if (!qtyInput.value || parseInt(qtyInput.value) < 1) qtyInput.value = 1
    dropdown.style.display = "none"

    this.recalcRow(row)
  }

  hideDropdown(event) {
    const row = event.target.closest("tr")
    if (!row) return
    setTimeout(() => {
      const dropdown = row.querySelector(".item-dropdown")
      if (dropdown) dropdown.style.display = "none"
    }, 150)
  }

  updateSubtotal(event) {
    const input = event.target
    if (parseInt(input.value) < 1) input.value = 1
    this.recalcRow(input.closest("tr"))
  }

  // ---- Modal Novo Produto ----

  openNovoItemModal() {
    this.novoItemModalTarget.style.display = "flex"
    this.novoItemFeedbackTarget.textContent = ""
    this.novoItemFormTarget.reset()
  }

  closeNovoItemModal() {
    this.novoItemModalTarget.style.display = "none"
  }

  closeNovoItemModalOnBackdrop(event) {
    if (event.target === this.novoItemModalTarget) this.closeNovoItemModal()
  }

  async submitNovoItem(event) {
    event.preventDefault()
    const form = this.novoItemFormTarget
    const feedback = this.novoItemFeedbackTarget
    const btn = form.querySelector("button[type=submit]")

    btn.disabled = true
    btn.textContent = "Salvando..."
    feedback.textContent = ""

    try {
      const resp = await fetch(form.action, {
        method: "POST",
        headers: { "Accept": "application/json", "X-CSRF-Token": document.querySelector("meta[name=csrf-token]").content },
        body: new FormData(form)
      })

      const data = await resp.json()

      if (resp.ok) {
        this.itemsValue = [...this.itemsValue, { id: data.id, descricao: data.descricao, preco_custo: data.preco_custo, estoque: data.quantidade_estoque }]
        this.closeNovoItemModal()
        // Adiciona o novo item automaticamente ao carrinho
        this.addItem()
        const lastRow = this.itemsBodyTarget.lastElementChild
        const searchInput = lastRow.querySelector(".item-search-input")
        const hiddenInput = lastRow.querySelector("input[name*='item_id']")
        const priceInput = lastRow.querySelector("input[name*='preco_unitario']")
        lastRow.querySelector(".item-dropdown").style.display = "none"
        searchInput.value = data.descricao
        hiddenInput.value = data.id
        priceInput.value = parseFloat(data.preco_custo).toFixed(2)
        this.recalcRow(lastRow)
      } else {
        const msgs = Object.values(data).flat()
        feedback.textContent = msgs.join(", ")
        feedback.style.color = "#ef4444"
      }
    } catch {
      feedback.textContent = "Erro de conexão. Tente novamente."
      feedback.style.color = "#ef4444"
    } finally {
      btn.disabled = false
      btn.textContent = "Salvar Produto"
    }
  }

  // ---- Helpers ----

  recalcRow(row) {
    const qty = parseFloat(row.querySelector("input[name*='quantidade']")?.value) || 0
    const price = parseFloat(row.querySelector("input[name*='preco_unitario']")?.value) || 0
    const subtotalEl = row.querySelector(".cart-subtotal")
    if (subtotalEl) subtotalEl.textContent = this.formatCurrency(qty * price)
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
      const hidden = row.querySelector("input[name*='item_id']")
      if (hidden && hidden.value == itemId) found = row
    })
    return found
  }

  formatCurrency(value) {
    return value.toLocaleString("pt-BR", { style: "currency", currency: "BRL" })
  }
}
