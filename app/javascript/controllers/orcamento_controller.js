import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["itemsBody", "total", "rowTemplate"]
  static values = { items: Array }

  connect() {
    this.updateTotal()
  }

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

    const price = this.getPriceForItem(itemId)
    const priceInput = currentRow.querySelector("input[name*='preco_unitario']")
    priceInput.value = price.toFixed(2)
    this.recalcRow(currentRow)
  }

  updateSubtotal(event) {
    this.recalcRow(event.target.closest("tr"))
  }

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

  getPriceForItem(itemId) {
    const item = this.itemsValue.find(i => i.id == itemId)
    return item ? item.preco : 0
  }

  formatCurrency(value) {
    return value.toLocaleString("pt-BR", { style: "currency", currency: "BRL" })
  }
}
