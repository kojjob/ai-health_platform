import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "toggleButton", 
    "monthlyPrice", 
    "annualPrice",
    "monthlyText",
    "annualText"
  ]
  
  static values = {
    monthly: Boolean
  }

  connect() {
    this.monthlyValue = true
    this.updateTogglePosition()
    this.updateUI()
  }

  toggle() {
    this.monthlyValue = !this.monthlyValue
    this.updateTogglePosition()
    this.updateUI()
  }

  updateTogglePosition() {
    if (this.hasToggleButtonTarget) {
      this.toggleButtonTarget.style.transform = this.monthlyValue ? 'translateX(0)' : 'translateX(40px)'
    }
  }

  updateUI() {
    // Update prices visibility
    if (this.hasMonthlyPriceTarget && this.hasAnnualPriceTarget) {
      this.monthlyPriceTargets.forEach(el => {
        if (this.monthlyValue) {
          el.style.display = 'block'
        } else {
          el.style.display = 'none'
        }
      })
      this.annualPriceTargets.forEach(el => {
        if (this.monthlyValue) {
          el.style.display = 'none'
        } else {
          el.style.display = 'block'
        }
      })
    }

    // Update text styling
    if (this.hasMonthlyTextTarget && this.hasAnnualTextTarget) {
      this.monthlyTextTarget.classList.toggle('text-blue-600', this.monthlyValue)
      this.annualTextTarget.classList.toggle('text-blue-600', !this.monthlyValue)
    }

    // Update ARIA attributes
    if (this.hasToggleButtonTarget) {
      this.toggleButtonTarget.setAttribute('aria-checked', !this.monthlyValue)
    }
  }
}
