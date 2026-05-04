import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["itemsBody", "total", "rowTemplate", "modal", "clienteSelect", "modalOrcamentosContainer", "modalAvisoCliente"]
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

  async openModal() {
    this.modalTarget.style.display = "flex"
    
    const clienteId = this.clienteSelectTarget.value
    const container = this.modalOrcamentosContainerTarget
    const aviso = this.modalAvisoClienteTarget

    if (!clienteId) {
      aviso.style.display = "block"
      container.innerHTML = ""
      return
    }

    aviso.style.display = "none"
    container.innerHTML = '<p class="modal-loading" style="padding: 20px; text-align: center; color: #6b7280;">Buscando orçamentos...</p>'

    try {
      const resp = await fetch(`/orcamentos/por_cliente?cliente_id=${clienteId}`, {
        headers: { "Accept": "application/json" }
      })
      
      const orcamentos = await resp.json()

      if (orcamentos.length === 0) {
        container.innerHTML = '<p class="modal-empty" style="padding: 20px; text-align: center; color: #6b7280;">Nenhum orçamento encontrado para este cliente.</p>'
        return
      }

      // Pega a data de hoje (zerando as horas para comparar apenas os dias)
      const hoje = new Date()
      hoje.setHours(0, 0, 0, 0)

      container.innerHTML = orcamentos.map(o => {
        // Lógica para transformar a string de data que vem do banco em um objeto de Data do JS
        let dataExpirou = false
        if (o.data_validade) {
          let partesData
          let dataValidadeJS
          // Verifica se a data veio no formato DD/MM/YYYY ou YYYY-MM-DD
          if (o.data_validade.includes("/")) {
            partesData = o.data_validade.split("/")
            dataValidadeJS = new Date(partesData[2], partesData[1] - 1, partesData[0])
          } else {
            partesData = o.data_validade.split("-")
            dataValidadeJS = new Date(partesData[0], partesData[1] - 1, partesData[2])
          }
          
          if (dataValidadeJS < hoje) {
            dataExpirou = true
          }
        }

        // Se estiver Expirado: Renderiza o cartão Cinza, sem o data-action de clique e com texto Vermelho
        if (dataExpirou) {
          return `
            <div class="modal-orcamento-card expirado" 
                 style="border: 1px solid #e5e7eb; border-radius: 8px; padding: 15px; margin-bottom: 10px; background-color: #f3f4f6; opacity: 0.75; cursor: not-allowed;">
              <div class="modal-orc-header" style="display: flex; justify-content: space-between; margin-bottom: 10px; border-bottom: 1px solid #e5e7eb; padding-bottom: 8px;">
                <span class="modal-orc-id" style="font-weight: 600; color: #9ca3af; text-decoration: line-through;">Orçamento #${o.id}</span>
                <span class="modal-orc-date" style="font-size: 0.85rem; color: #ef4444; font-weight: bold;">
                  Expirado em ${o.data_validade}
                </span>
              </div>
              <div class="modal-orc-itens" style="font-size: 0.9rem; color: #9ca3af;">
                ${o.itens.map(i => `<span>${i.descricao} × ${i.quantidade}</span>`).join(" &nbsp;|&nbsp; ")}
              </div>
            </div>
          `
        } 
        // Se for Válido: Renderiza o cartão normal azul, clicável e que carrega o orçamento
        else {
          return `
            <div class="modal-orcamento-card" data-action="click->venda#loadOrcamento"
                 data-orcamento='${JSON.stringify(o)}' 
                 style="border: 1px solid #e5e7eb; border-radius: 8px; padding: 15px; margin-bottom: 10px; cursor: pointer; transition: all 0.2s; background-color: #ffffff;">
              <div class="modal-orc-header" style="display: flex; justify-content: space-between; margin-bottom: 10px; border-bottom: 1px solid #f3f4f6; padding-bottom: 8px;">
                <span class="modal-orc-id" style="font-weight: 600; color: #3b82f6;">Orçamento #${o.id}</span>
                <span class="modal-orc-date" style="font-size: 0.85rem; color: #6b7280;">${o.data} &nbsp;·&nbsp; Válido até ${o.data_validade}</span>
              </div>
              <div class="modal-orc-itens" style="font-size: 0.9rem; color: #4b5563;">
                ${o.itens.map(i => `<span>${i.descricao} × ${i.quantidade}</span>`).join(" &nbsp;|&nbsp; ")}
              </div>
            </div>
          `
        }
      }).join("")

    } catch (error) {
      container.innerHTML = '<p style="color: #ef4444; text-align: center;">Erro ao buscar orçamentos.</p>'
    }
  }

  closeModal() {
    this.modalTarget.style.display = "none"
  }

  closeModalOnBackdrop(event) {
    if (event.target === this.modalTarget) this.closeModal()
  }

  loadOrcamento(event) {
    const card = event.currentTarget
    const orcamento = JSON.parse(card.dataset.orcamento)

    this.itemsBodyTarget.querySelectorAll("tr").forEach(row => {
      const destroyInput = row.querySelector("input[name*='_destroy']")
      if (destroyInput) {
        destroyInput.value = "1"
        row.style.display = "none"
      } else {
        row.remove()
      }
    })

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