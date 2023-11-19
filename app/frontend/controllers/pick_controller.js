import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['submit', 'answer']

  static values = {
    completed: Boolean
  }

  connect() {
    this.element.addEventListener('turbo:submit-end', this.submitEnd.bind(this))
  }

  toggleSubmitButton() {
    this.submitTarget.classList.remove('hidden')
  }

  selectAnswerWithKeyboard(e) {
    if (!['1', '2', '3', '4'].includes(e.key)) {
      return
    }

    const answerIndex = parseInt(e.key) - 1
    const answerInput = this.answerTargets[answerIndex]

    if (!answerInput) {
      return
    }

    answerInput.checked = true
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
