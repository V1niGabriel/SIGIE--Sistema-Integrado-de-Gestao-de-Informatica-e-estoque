import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
 connect(){ console.log("O Stimulus conectou o Carrossel com sucesso!");
    this.index = 0;
    this.startTimer();
  }
  // 1. Definimos os nossos alvos (substitui o querySelectorAll)
  static targets = [ "slide", "line" ]

  connect() {
    this.index = 0; // Começa no primeiro slide
    this.startTimer();
  }

  // Desliga o timer se o usuário sair da página (evita bugs de memória)
  disconnect() {
    this.stopTimer();
  }

  // Função para mostrar o slide atual
  showCurrentSlide() {
    // O 'toggle' do classList para adicionar a classe se o índice bater, ou remover se não bater
    this.slideTargets.forEach((slide, i) => {
      slide.classList.toggle("active", i === this.index);
    });

    this.lineTargets.forEach((line, i) => {
      line.classList.toggle("active", i === this.index);
    });
  }

  // Avança para o próximo slide
  nextSlide() {
    this.index = (this.index + 1) % this.slideTargets.length;
    this.showCurrentSlide();
  }

  // Lógica do temporizador
  startTimer() {
    this.timer = setInterval(() => {
      this.nextSlide();
    }, 8000);
  }

  stopTimer() {
    if (this.timer) clearInterval(this.timer);
  }

  // Ação ativada quando o usuário clica em uma das linhas
  goToSlide(event) {
    // Pegamos o número do slide direto do HTML usando Params do Stimulus
    this.index = event.params.index;
    this.showCurrentSlide();

    // Zera o timer
    this.stopTimer();
    this.startTimer();
  }
}