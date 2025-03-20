import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["count", "button"]
  
  like() {
    // Логика анимации лайка
    this.buttonTarget.classList.add("liked")
    this.countTarget.textContent = parseInt(this.countTarget.textContent) + 1
  }
  
  unlike() {
    // Логика анимации дизлайка
    this.buttonTarget.classList.remove("liked")
    this.countTarget.textContent = parseInt(this.countTarget.textContent) - 1
  }
}