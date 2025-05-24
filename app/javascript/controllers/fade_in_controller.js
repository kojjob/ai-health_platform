import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static classes = ["visible"]
  static values = { delay: Number }
  
  connect() {
    // Set initial state
    this.element.style.opacity = "0"
    this.element.style.transform = "translateY(20px)"
    this.element.style.transition = "opacity 0.6s ease-out, transform 0.6s ease-out"
    
    // Apply delay if specified
    if (this.hasDelayValue && this.delayValue > 0) {
      this.element.style.transitionDelay = `${this.delayValue}ms`
    }
    
    // Use Intersection Observer for better performance
    this.observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          this.fadeIn()
          this.observer.unobserve(entry.target)
        }
      })
    }, { 
      threshold: 0.1,
      rootMargin: "0px 0px -50px 0px"
    })

    this.observer.observe(this.element)
  }
  
  disconnect() {
    if (this.observer) {
      this.observer.disconnect()
    }
  }
  
  fadeIn() {
    this.element.style.opacity = "1"
    this.element.style.transform = "translateY(0)"
    this.element.classList.add('animate-fade-in-up')
    
    if (this.hasVisibleClass) {
      this.element.classList.add(this.visibleClass)
    }
  }
}