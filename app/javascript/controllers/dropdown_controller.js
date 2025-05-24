import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]
  
  connect() {
    // Close on escape key
    this.escapeHandler = this.escapeHandler.bind(this)
    this.outsideClickHandler = this.outsideClickHandler.bind(this)
    
    document.addEventListener('keydown', this.escapeHandler)
    document.addEventListener('click', this.outsideClickHandler)
  }
  
  disconnect() {
    document.removeEventListener('keydown', this.escapeHandler)
    document.removeEventListener('click', this.outsideClickHandler)
  }
  
  escapeHandler(e) {
    if (e.key === "Escape" && this.isOpen()) {
      this.hide()
    }
  }
  
  outsideClickHandler(e) {
    // Don't close if clicking inside the dropdown element
    if (this.element.contains(e.target)) {
      return
    }
    
    // Only close if the dropdown is currently visible
    if (this.isOpen()) {
      this.hide()
    }
  }
  
  toggle(event) {
    // Prevent the click from bubbling up to the document
    if (event) {
      event.preventDefault()
      event.stopPropagation()
    }
    
    if (this.isOpen()) {
      this.hide()
    } else {
      this.closeOtherDropdowns()
      this.show()
    }
  }
  
  show() {
    if (!this.hasMenuTarget) return
    
    // Close any other open dropdowns first
    this.closeOtherDropdowns()
    
    this.menuTarget.classList.remove('invisible', 'opacity-0', 'scale-95')
    this.menuTarget.classList.add('visible', 'opacity-100', 'scale-100')
  }
  
  hide() {
    if (!this.hasMenuTarget) return
    
    this.menuTarget.classList.remove('visible', 'opacity-100', 'scale-100')
    this.menuTarget.classList.add('invisible', 'opacity-0', 'scale-95')
  }
  
  isOpen() {
    if (!this.hasMenuTarget) return false
    return this.menuTarget.classList.contains('visible') && 
           this.menuTarget.classList.contains('opacity-100')
  }
  
  closeOtherDropdowns() {
    // Find other dropdown controllers and close them
    const otherDropdowns = document.querySelectorAll('[data-controller*="dropdown"]')
    otherDropdowns.forEach(dropdown => {
      if (dropdown !== this.element) {
        const controller = this.application.getControllerForElementAndIdentifier(dropdown, 'dropdown')
        if (controller && controller.hide) {
          controller.hide()
        }
      }
    })
  }
}
