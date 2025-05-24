import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["question", "answer"]
  
  toggle(event) {
    const button = event.currentTarget
    const index = button.dataset.index
    const answer = this.answerTargets.find(target => target.dataset.index === index)
    const icon = button.querySelector("i")
    
    answer.classList.toggle("hidden")
    icon.classList.toggle("transform")
    icon.classList.toggle("rotate-180")
  }
}
