import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button"]
  
  connect() {
    this.toggleButtonVisibility()
    window.addEventListener('scroll', this.toggleButtonVisibility.bind(this))
  }
  
  disconnect() {
    window.removeEventListener('scroll', this.toggleButtonVisibility.bind(this))
  }
  
  toggleButtonVisibility() {
    if (window.pageYOffset > 300) {
      this.buttonTarget.classList.remove('opacity-0', 'pointer-events-none')
      this.buttonTarget.classList.add('opacity-100')
    } else {
      this.buttonTarget.classList.add('opacity-0', 'pointer-events-none')
      this.buttonTarget.classList.remove('opacity-100')
    }
  }
  
  scrollToTop() {
    window.scrollTo({
      top: 0,
      behavior: 'smooth'
    })
    
    // Track this action for analytics
    if (typeof gtag === 'function') {
      gtag('event', 'scroll_to_top', {
        'page': window.location.pathname
      })
    }
  }
}
