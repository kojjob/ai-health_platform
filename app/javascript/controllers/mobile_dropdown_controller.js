import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "icon"]
  
  connect() {
    // Mobile dropdown controller connected
  }
  
  toggle(event) {
    if (event) {
      event.preventDefault()
      event.stopPropagation()
    }
    
    if (this.hasContentTarget) {
      this.contentTarget.classList.toggle('hidden')
    }
    
    if (this.hasIconTarget) {
      this.iconTarget.classList.toggle('rotate-180')
    }
  }
}
