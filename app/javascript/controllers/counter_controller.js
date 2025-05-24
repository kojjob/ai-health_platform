import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["number"]
  static values = { endValue: Number }

  connect() {
    this.animateValue()
  }

  animateValue() {
    const duration = 2000
    const start = 0
    const end = parseInt(this.numberTarget.dataset.counterEndValue)
    const range = end - start
    const increment = end > start ? 1 : -1
    const stepTime = Math.abs(Math.floor(duration / range))
    let current = start
    
    const timer = setInterval(() => {
      current += increment
      this.numberTarget.textContent = current
      
      if (current === end) {
        clearInterval(timer)
      }
    }, stepTime)
  }
}