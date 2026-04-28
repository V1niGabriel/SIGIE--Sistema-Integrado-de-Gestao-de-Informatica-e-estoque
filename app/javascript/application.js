// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Intercepta o método padrão de confirmação do Turbo
document.addEventListener("turbo:load", () => {
  
  // Evita que o evento seja criado duplicado ao navegar pelas páginas
  if (window.customConfirmSetup) return;
  window.customConfirmSetup = true;

  Turbo.setConfirmMethod((message, element) => {
    return new Promise((resolve, reject) => {
      
      // Cria a camada escura do fundo
      const overlay = document.createElement('div');
      overlay.className = 'custom-modal-overlay';
      
      // Cria a caixa branca do modal
      const modal = document.createElement('div');
      modal.className = 'custom-modal-box';
      
      // Preenche com o HTML e a mensagem que veio do botão
      modal.innerHTML = `
        <h3 class="custom-modal-title">Confirmação de Exclusão</h3>
        <p class="custom-modal-text">${message}</p>
        <div style="display: flex; justify-content: flex-end; gap: 15px;">
          <button id="custom-confirm-cancel" class="btn-secondary">Cancelar</button>
          <button id="custom-confirm-ok" class="btn-danger">Sim, Excluir</button>
        </div>
      `;
      
      // Coloca o modal dentro do overlay e joga na tela
      overlay.appendChild(modal);
      document.body.appendChild(overlay);
      
      // Ação do botão "Sim, Excluir"
      document.getElementById('custom-confirm-ok').addEventListener('click', () => {
        overlay.remove(); // Some com o modal
        resolve(true);    // Deixa o Rails continuar e deletar o item
      });
      
      // Ação do botão "Cancelar"
      document.getElementById('custom-confirm-cancel').addEventListener('click', () => {
        overlay.remove(); // Some com o modal
        resolve(false);   // Trava o Rails e não deleta nada
      });
    });
  });
});