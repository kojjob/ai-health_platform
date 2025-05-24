import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["screen", "caption", "currentStep"]
  
  connect() {
    this.currentIndex = 0
    this.totalScreens = this.screenTargets.length
    this.autoRotateInterval = null
    this.startAutoRotate()
    this.updateScreen()
  }
  
  disconnect() {
    this.stopAutoRotate()
  }
  
  startAutoRotate() {
    this.autoRotateInterval = setInterval(() => {
      this.next()
    }, 4000)
  }
  
  stopAutoRotate() {
    if (this.autoRotateInterval) {
      clearInterval(this.autoRotateInterval)
    }
  }
  
  next() {
    this.currentIndex = (this.currentIndex + 1) % this.totalScreens
    this.updateScreen()
  }
  
  previous() {
    this.currentIndex = (this.currentIndex - 1 + this.totalScreens) % this.totalScreens
    this.updateScreen()
  }
  
  goToScreen(event) {
    const index = parseInt(event.currentTarget.dataset.index)
    if (!isNaN(index) && index >= 0 && index < this.totalScreens) {
      this.currentIndex = index
      this.updateScreen()
      this.restartAutoRotate()
    }
  }
  
  updateScreen() {
    // Hide all screens
    this.screenTargets.forEach((screen, index) => {
      if (index === this.currentIndex) {
        screen.classList.remove("hidden")
        screen.classList.add("animate-fade-in")
      } else {
        screen.classList.add("hidden")
        screen.classList.remove("animate-fade-in")
      }
    })
    
    // Update captions
    this.captionTargets.forEach((caption, index) => {
      if (index === this.currentIndex) {
        caption.classList.remove("hidden")
        caption.classList.add("animate-fade-in")
      } else {
        caption.classList.add("hidden")
        caption.classList.remove("animate-fade-in")
      }
    })
    
    // Update current step indicator
    if (this.hasCurrentStepTarget) {
      this.currentStepTarget.textContent = `${this.currentIndex + 1}/${this.totalScreens}`
    }
  }
  
  restartAutoRotate() {
    this.stopAutoRotate()
    this.startAutoRotate()
  }
  
  pauseRotation() {
    this.stopAutoRotate()
  }
  
  resumeRotation() {
    this.startAutoRotate()
  }
}
