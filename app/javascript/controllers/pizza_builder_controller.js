import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = []

  connect() {
    this.updateFlavorsVisibility()
  }

  // Ação ao mudar o produto (Pizza Salgada vs Doce)
  changeProduct(event) {
    const radio = event.currentTarget
    const sizes = JSON.parse(radio.dataset.sizes || "[]")
    const container = document.getElementById("pizza-sizes-container")
    
    if (!container) return

    // Limpar tamanhos antigos
    container.innerHTML = ""

    // Inserir os novos tamanhos do produto selecionado
    sizes.forEach((size, idx) => {
      const label = document.createElement("label")
      label.className = "relative flex flex-col items-center justify-center p-3 bg-zinc-950 border border-zinc-800 rounded-xl cursor-pointer text-center hover:border-orange-500 transition-all select-none"
      
      const input = document.createElement("input")
      input.type = "radio"
      input.name = "product_size_id"
      input.value = size.id
      input.dataset.action = "change->pizza-builder#changeSize"
      input.dataset.maxFlavors = size.max_flavors
      input.dataset.price = size.price
      input.className = "sr-only"
      if (idx === 0) input.checked = true

      const nameSpan = document.createElement("span")
      nameSpan.className = "text-lg font-bold text-white"
      nameSpan.textContent = size.size_name

      const priceSpan = document.createElement("span")
      priceSpan.className = "text-xs text-orange-400 font-extrabold mt-1"
      priceSpan.textContent = `R$ ${size.price.toFixed(2)}`

      const descSpan = document.createElement("span")
      descSpan.className = "text-[9px] text-zinc-500 mt-0.5"
      descSpan.textContent = `${size.max_flavors} sabor(es)`

      label.appendChild(input)
      label.appendChild(nameSpan)
      label.appendChild(priceSpan)
      label.appendChild(descSpan)

      container.appendChild(label)
    })

    // Atualizar visibilidade dos sabores conforme o tamanho padrão selecionado
    this.updateFlavorsVisibility()
  }

  // Ação ao mudar o tamanho da pizza
  changeSize(event) {
    // Adicionar borda amarela de foco ao tamanho selecionado (efeito visual)
    const inputs = document.getElementsByName("product_size_id")
    inputs.forEach(input => {
      const parent = input.parentElement
      if (input.checked) {
        parent.classList.add("border-orange-500", "ring-1", "ring-orange-500")
      } else {
        parent.classList.remove("border-orange-500", "ring-1", "ring-orange-500")
      }
    })

    this.updateFlavorsVisibility()
  }

  // Controla se o segundo sabor deve ser exibido conforme capacidade do tamanho
  updateFlavorsVisibility() {
    const selectedSize = document.querySelector('input[name="product_size_id"]:checked')
    const sabor2Container = document.getElementById("sabor-2-container")
    const sabor2Select = document.getElementById("sabor-2-select")

    if (!selectedSize || !sabor2Container) return

    const maxFlavors = parseInt(selectedSize.dataset.maxFlavors || "1")

    if (maxFlavors > 1) {
      sabor2Container.style.display = "block"
      if (sabor2Select) sabor2Select.disabled = false
    } else {
      sabor2Container.style.display = "none"
      if (sabor2Select) {
        sabor2Select.value = "" // limpa se for inteira
        sabor2Select.disabled = true
      }
    }
  }
}
