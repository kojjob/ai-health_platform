import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="newsletter-form"
export default class extends Controller {
  static targets = ["form", "email", "submit"]

  connect() {
    this.originalSubmitText = this.submitTarget.textContent
  }

  async submit(event) {
    event.preventDefault()
    
    const email = this.emailTarget.value.trim()
    
    if (!email) {
      this.showError("Please enter your email address")
      return
    }

    if (!this.isValidEmail(email)) {
      this.showError("Please enter a valid email address")
      return
    }

    try {
      this.setLoading(true)
      
      const formData = new FormData(this.formTarget)
      
      // Get CSRF token from meta tag
      const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      
      const response = await fetch(this.formTarget.action, {
        method: 'POST',
        body: formData,
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-Token': csrfToken
        }
      })

      const data = await response.json()

      if (data.success) {
        this.showSuccess(data.message)
        this.formTarget.reset()
      } else {
        this.showError(data.message || "Something went wrong. Please try again.")
      }
    } catch (error) {
      console.error('Newsletter subscription error:', error)
      this.showError("Network error. Please check your connection and try again.")
    } finally {
      this.setLoading(false)
    }
  }

  isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    return emailRegex.test(email)
  }

  setLoading(isLoading) {
    this.submitTarget.disabled = isLoading
    this.submitTarget.textContent = isLoading ? "Subscribing..." : this.originalSubmitText
    
    if (isLoading) {
      this.submitTarget.classList.add("opacity-75", "cursor-not-allowed")
    } else {
      this.submitTarget.classList.remove("opacity-75", "cursor-not-allowed")
    }
  }

  showSuccess(message) {
    this.removeExistingMessages()
    
    const successDiv = document.createElement('div')
    successDiv.className = 'mt-4 p-4 bg-green-100 border border-green-400 text-green-700 rounded-lg'
    successDiv.innerHTML = `
      <div class="flex items-center">
        <i class="fas fa-check-circle mr-2"></i>
        <span>${message}</span>
      </div>
    `
    
    this.formTarget.parentNode.insertBefore(successDiv, this.formTarget.nextSibling)
    
    // Remove success message after 5 seconds
    setTimeout(() => {
      if (successDiv.parentNode) {
        successDiv.remove()
      }
    }, 5000)
  }

  showError(message) {
    this.removeExistingMessages()
    
    const errorDiv = document.createElement('div')
    errorDiv.className = 'mt-4 p-4 bg-red-100 border border-red-400 text-red-700 rounded-lg'
    errorDiv.innerHTML = `
      <div class="flex items-center">
        <i class="fas fa-exclamation-circle mr-2"></i>
        <span>${message}</span>
      </div>
    `
    
    this.formTarget.parentNode.insertBefore(errorDiv, this.formTarget.nextSibling)
    
    // Remove error message after 5 seconds
    setTimeout(() => {
      if (errorDiv.parentNode) {
        errorDiv.remove()
      }
    }, 5000)
  }

  removeExistingMessages() {
    const existingMessages = this.formTarget.parentNode.querySelectorAll('.bg-green-100, .bg-red-100')
    existingMessages.forEach(msg => msg.remove())
  }
}
