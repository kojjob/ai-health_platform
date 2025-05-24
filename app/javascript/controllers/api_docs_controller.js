import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["navigation"]
  
  connect() {
    // Add event listener to the toggle button
    const toggleButton = document.getElementById("toggleApiNav")
    if (toggleButton) {
      toggleButton.addEventListener("click", this.toggleNavigation.bind(this))
    }
    
    // Close navigation when clicking on a link (on mobile)
    const navigationLinks = document.querySelectorAll("#apiNavContent a")
    navigationLinks.forEach(link => {
      link.addEventListener("click", () => {
        if (window.innerWidth < 1024) { // lg breakpoint in Tailwind
          this.hideNavigation()
        }
      })
    })
  }
  
  toggleNavigation() {
    const apiNavContent = document.getElementById("apiNavContent")
    const toggleButton = document.getElementById("toggleApiNav")
    
    if (apiNavContent) {
      apiNavContent.classList.toggle("hidden")
      
      // Toggle chevron icon
      const chevronIcon = toggleButton.querySelector(".fas.fa-chevron-down")
      if (chevronIcon) {
        chevronIcon.classList.toggle("fa-chevron-down")
        chevronIcon.classList.toggle("fa-chevron-up")
      }
    }
  }
  
  hideNavigation() {
    const apiNavContent = document.getElementById("apiNavContent")
    const toggleButton = document.getElementById("toggleApiNav")
    
    if (apiNavContent) {
      apiNavContent.classList.add("hidden")
      
      // Reset chevron icon
      const chevronIcon = toggleButton.querySelector(".fas")
      if (chevronIcon && chevronIcon.classList.contains("fa-chevron-up")) {
        chevronIcon.classList.remove("fa-chevron-up")
        chevronIcon.classList.add("fa-chevron-down")
      }
    }
  }
}
