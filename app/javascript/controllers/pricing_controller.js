import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "toggleButton", 
    "monthlyPrice", 
    "annualPrice",
    "monthlyText",
    "annualText",
    "savingsLabel"
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
    // Update prices visibility with smooth transitions
    if (this.hasMonthlyPriceTarget && this.hasAnnualPriceTarget) {
      this.monthlyPriceTargets.forEach(el => {
        if (this.monthlyValue) {
          el.style.opacity = '1'
          el.style.transform = 'translateY(0)'
          el.style.display = 'block'
        } else {
          el.style.opacity = '0'
          el.style.transform = 'translateY(-10px)'
          setTimeout(() => { el.style.display = 'none' }, 200)
        }
      })
      this.annualPriceTargets.forEach(el => {
        if (this.monthlyValue) {
          el.style.opacity = '0'
          el.style.transform = 'translateY(-10px)'
          setTimeout(() => { el.style.display = 'none' }, 200)
        } else {
          el.style.display = 'block'
          setTimeout(() => {
            el.style.opacity = '1'
            el.style.transform = 'translateY(0)'
          }, 50)
        }
      })
    }

    // Update text styling
    if (this.hasMonthlyTextTarget && this.hasAnnualTextTarget) {
      this.monthlyTextTarget.classList.toggle('text-blue-600', this.monthlyValue)
      this.monthlyTextTarget.classList.toggle('font-semibold', this.monthlyValue)
      this.annualTextTarget.classList.toggle('text-blue-600', !this.monthlyValue)
      this.annualTextTarget.classList.toggle('font-semibold', !this.monthlyValue)
    }

    // Update savings label visibility
    if (this.hasSavingsLabelTarget) {
      this.savingsLabelTargets.forEach(el => {
        if (this.monthlyValue) {
          el.style.opacity = '0'
          el.style.transform = 'scale(0.8)'
        } else {
          el.style.opacity = '1'
          el.style.transform = 'scale(1)'
        }
      })
    }

    // Update ARIA attributes
    if (this.hasToggleButtonTarget) {
      this.toggleButtonTarget.setAttribute('aria-checked', !this.monthlyValue)
    }
  }
}
