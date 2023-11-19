import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['submit', 'answer']

  static values = {
    completed: Boolean
  }

  connect() {
    console.log(this.completedValue)
    this.element.addEventListener('turbo:submit-end', this.submitEnd.bind(this))
  }

  toggleSubmitButton() {
    this.submitTarget.classList.remove('hidden')
  }

  submit() {
    if (this.completedValue) {
      document.getElementById('next-step-button').click()
    } else if (this.answerTargets.some((answer) => answer.checked)) {
      this.element.requestSubmit()
    }
  }

  submitEnd() {
    this.completedValue = true
    this.submitTarget.classList.add('pointer-events-none')
    this.submitTarget.classList.add('opacity-50')
    this.answerTargets.forEach((answer) => answer.setAttribute('disabled', 'disabled'))
  }
}
