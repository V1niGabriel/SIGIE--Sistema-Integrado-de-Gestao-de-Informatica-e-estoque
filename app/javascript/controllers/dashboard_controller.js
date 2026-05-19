import { Controller } from "@hotwired/stimulus"

// Chart.js carregado via <script> UMD no layout — sempre lido em runtime
export default class extends Controller {
  static targets = ["modal", "chartVendas", "chartOrcamentos", "chartCompras", "chartLucro"]

  // Paleta consistente com o tema do sistema
  #BLUE   = "#2b2881"
  #YELLOW = "#f59e0b"
  #RED    = "#ef4444"
  #GREEN  = "#16a34a"
  #GRAY   = "#9ca3af"
  #charts = {}

  openModal({ params: { modal } }) {
    const el = document.getElementById(modal)
    if (!el) return
    // suporta tanto o estilo dash (classe) quanto o estilo vendas (display)
    if (el.classList.contains("dash-modal-overlay")) {
      el.classList.add("dash-modal-overlay--open")
    } else {
      el.style.display = "flex"
    }
    document.body.style.overflow = "hidden"
    this.#initChart(modal)
  }

  closeModal() {
    this.modalTargets.forEach(m => {
      if (m.classList.contains("dash-modal-overlay")) {
        m.classList.remove("dash-modal-overlay--open")
      } else {
        m.style.display = "none"
      }
    })
    document.body.style.overflow = ""
  }

  closeOnOverlay(event) {
    if (event.target === event.currentTarget) this.closeModal()
  }

  // Fecha com ESC
  connect() {
    this._onKeydown = (e) => { if (e.key === "Escape") this.closeModal() }
    document.addEventListener("keydown", this._onKeydown)
  }

  disconnect() {
    document.removeEventListener("keydown", this._onKeydown)
  }

  // ── Inicialização lazy dos gráficos ─────────────────────────────
  #initChart(modal) {
    if (this.#charts[modal]) return  // já inicializado

    if (modal === "modal-vendas" && this.hasChartVendasTarget) {
      this.#charts[modal] = this.#lineChart(
        this.chartVendasTarget, "Faturamento (R$)", this.#BLUE, true
      )
    }

    if (modal === "modal-orcamentos" && this.hasChartOrcamentosTarget) {
      this.#charts[modal] = this.#lineChart(
        this.chartOrcamentosTarget, "Orçamentos criados", this.#YELLOW, false
      )
    }

    if (modal === "modal-compras" && this.hasChartComprasTarget) {
      this.#charts[modal] = this.#donutChart(this.chartComprasTarget)
    }

    if (modal === "modal-lucro" && this.hasChartLucroTarget) {
      this.#charts[modal] = this.#groupedBarChart(this.chartLucroTarget)
    }
  }

  #lineChart(canvas, label, color, isCurrency = false) {
    const labels = JSON.parse(canvas.dataset.labels || "[]")
    const values = JSON.parse(canvas.dataset.values || "[]")
    const fmtBRL = (v) => "R$ " + v.toLocaleString("pt-BR", { minimumFractionDigits: 2 })

    return new window.Chart(canvas, {
      type: "line",
      data: {
        labels,
        datasets: [{
          label,
          data: values,
          borderColor: color,
          backgroundColor: color + "20",
          borderWidth: 2,
          pointRadius: 2,
          pointHoverRadius: 6,
          pointHoverBackgroundColor: color,
          fill: true,
          tension: 0.4
        }]
      },
      options: {
        responsive: true,
        interaction: { mode: "index", intersect: false },
        plugins: {
          legend: { display: false },
          tooltip: {
            callbacks: isCurrency
              ? { label: (ctx) => `${label}: ${fmtBRL(ctx.parsed.y)}` }
              : {}
          }
        },
        scales: {
          y: {
            beginAtZero: true,
            ticks: {
              font: { size: 11 },
              callback: isCurrency ? (v) => "R$" + v.toLocaleString("pt-BR") : undefined
            },
            grid: { color: "#f3f4f6" }
          },
          x: {
            ticks: { font: { size: 11 }, maxTicksLimit: 12, maxRotation: 45 },
            grid: { display: false }
          }
        }
      }
    })
  }

  #groupedBarChart(canvas) {
    const labels  = JSON.parse(canvas.dataset.labels  || "[]")
    const receita = JSON.parse(canvas.dataset.receita || "[]")
    const custo   = JSON.parse(canvas.dataset.custo   || "[]")
    const fmtBRL  = (v) => "R$ " + v.toLocaleString("pt-BR", { minimumFractionDigits: 2 })

    return new window.Chart(canvas, {
      type: "line",
      data: {
        labels,
        datasets: [
          {
            label: "Receita (Vendas)",
            data: receita,
            borderColor: this.#BLUE,
            backgroundColor: this.#BLUE + "18",
            borderWidth: 2,
            pointRadius: labels.length > 20 ? 0 : 4,
            pointHoverRadius: 6,
            fill: true,
            tension: 0.3
          },
          {
            label: "Custo (Compras)",
            data: custo,
            borderColor: this.#RED,
            backgroundColor: this.#RED + "18",
            borderWidth: 2,
            pointRadius: labels.length > 20 ? 0 : 4,
            pointHoverRadius: 6,
            fill: true,
            tension: 0.3
          }
        ]
      },
      options: {
        responsive: true,
        interaction: { mode: "index", intersect: false },
        plugins: {
          legend: { position: "top", labels: { font: { size: 12 }, padding: 16 } },
          tooltip: {
            callbacks: { label: (ctx) => `${ctx.dataset.label}: ${fmtBRL(ctx.parsed.y)}` }
          }
        },
        scales: {
          y: {
            beginAtZero: true,
            ticks: {
              font: { size: 11 },
              callback: (v) => "R$" + v.toLocaleString("pt-BR")
            },
            grid: { color: "#f3f4f6" }
          },
          x: {
            ticks: { font: { size: 11 }, maxTicksLimit: 12, maxRotation: 45 },
            grid: { display: false }
          }
        }
      }
    })
  }

  #donutChart(canvas) {
    const pendentes  = parseInt(canvas.dataset.pendentes  || 0)
    const pagas      = parseInt(canvas.dataset.pagas      || 0)
    const canceladas = parseInt(canvas.dataset.canceladas || 0)
    return new window.Chart(canvas, {
      type: "doughnut",
      data: {
        labels: ["Pendentes", "Pagas", "Canceladas"],
        datasets: [{
          data: [pendentes, pagas, canceladas],
          backgroundColor: [this.#YELLOW, this.#GREEN, this.#RED],
          borderWidth: 2,
          borderColor: "#fff"
        }]
      },
      options: {
        responsive: true,
        plugins: {
          legend: {
            position: "bottom",
            labels: { font: { size: 12 }, padding: 16 }
          }
        },
        cutout: "65%"
      }
    })
  }
}
