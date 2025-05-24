import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["number"]
  static values = {
    start: { type: Number, default: 0 },
    end: { type: Number, default: 100 },
    duration: { type: Number, default: 2000 }, // milliseconds
    suffix: { type: String, default: "" },
    prefix: { type: String, default: "" }
  }
  
  connect() {
    this.hasAnimated = false
    this.setupIntersectionObserver()
  }
  
  disconnect() {
    if (this.observer) {
      this.observer.disconnect()
    }
  }
  
  setupIntersectionObserver() {
    this.observer = new IntersectionObserver(
      (entries) => {
        entries.forEach(entry => {
          if (entry.isIntersecting && !this.hasAnimated) {
            this.animate()
            this.hasAnimated = true
          }
        })
      },
      { threshold: 0.5 }
    )
    
    this.observer.observe(this.element)
  }
  
  animate() {
    const startTime = performance.now()
    const startValue = this.startValue
    const endValue = this.endValue
    const duration = this.durationValue
    
    // Add highlight class for visual emphasis
    this.numberTarget.classList.add('stats-animating')
    
    const updateNumber = (currentTime) => {
      const elapsed = currentTime - startTime
      const progress = Math.min(elapsed / duration, 1)
      
      // Enhanced easeOutBack easing function for more dynamic animation
      const c1 = 1.70158;
      const c3 = c1 + 1;
      const easedProgress = 1 + c3 * Math.pow(progress - 1, 3) + c1 * Math.pow(progress - 1, 2);
      
      const currentValue = Math.floor(startValue + (endValue - startValue) * easedProgress)
      
      // Format the number with commas for readability
      const formattedValue = this.formatNumber(currentValue)
      
      // Update the display
      this.numberTarget.textContent = `${this.prefixValue}${formattedValue}${this.suffixValue}`
      
      if (progress < 1) {
        requestAnimationFrame(updateNumber)
      } else {
        // Ensure we end with the exact target value
        const finalValue = this.formatNumber(endValue)
        this.numberTarget.textContent = `${this.prefixValue}${finalValue}${this.suffixValue}`
        
        // Remove highlight class after animation completes
        setTimeout(() => {
          this.numberTarget.classList.remove('stats-animating')
          this.numberTarget.classList.add('stats-completed')
        }, 300)
        
        // Track completion for analytics
        if (typeof gtag === 'function') {
          gtag('event', 'stats_animation_complete', {
            'event_category': 'engagement',
            'event_label': `${this.prefixValue}${finalValue}${this.suffixValue}`,
            'value': endValue
          })
        }
      }
    }
    
    requestAnimationFrame(updateNumber)
  }
  
  formatNumber(num) {
    // Add commas to numbers >= 1000
    if (num >= 1000) {
      return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")
    }
    return num.toString()
  }
  
  // Manual trigger for testing or special cases
  trigger() {
    if (!this.hasAnimated) {
      this.animate()
      this.hasAnimated = true
    }
  }
  
  // Reset animation (useful for re-triggering)
  reset() {
    this.hasAnimated = false
    this.numberTarget.textContent = `${this.prefixValue}${this.formatNumber(this.startValue)}${this.suffixValue}`
  }
}
