import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['submit', 'answer']

  connect() {
    this.element.addEventListener('turbo:submit-end', this.submit.bind(this))
  }

  toggleSubmitButton() {
    this.submitTarget.classList.remove('hidden')
  }

  submit() {
    this.submitTarget.classList.add('pointer-events-none')
    this.submitTarget.classList.add('opacity-50')
    this.answerTargets.forEach((answer) => answer.setAttribute('disabled', 'disabled'))
  }
}
