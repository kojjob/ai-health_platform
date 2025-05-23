import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "icon"]
  
  connect() {
    console.log("Mobile dropdown controller connected")
  }
  
  toggle(event) {
    if (event) {
      event.preventDefault()
      event.stopPropagation()
    }
    
    console.log("Mobile dropdown toggle called")
    
    if (this.hasContentTarget) {
      this.contentTarget.classList.toggle("hidden")
      console.log("Content toggled, hidden:", this.contentTarget.classList.contains("hidden"))
    }
    
    if (this.hasIconTarget) {
      this.iconTarget.classList.toggle("rotate-180")
    }
  }
}
