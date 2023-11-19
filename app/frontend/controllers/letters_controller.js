import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['failed', 'cell', 'nextStep']

  static classes = ['wrongLetter', 'correctLetter']

  static values = {
    term: Array
  }

  connect() {
    this.selectedChars = []
  }

  select(e) {
    const currentTarget = e.currentTarget
    if (e.params.char === this.termValue[this.selectedChars.length]) {
      this.cellTargets[this.selectedChars.length].classList.add(...this.correctLetterClasses)
      this.cellTargets[this.selectedChars.length].innerHTML = e.params.char
      this.selectedChars.push(e.params.char)

      currentTarget.setAttribute('disabled', 'disabled')

      if (this.stepCompleted()) {
        this.nextStepTarget.classList.remove('hidden')
        this.nextStepTarget.classList.add('flex')
      }
    } else {
      currentTarget.classList.add(...this.wrongLetterClasses)

      this.failedTarget.value = 'true'
      setTimeout(() => {
        currentTarget.classList.remove(...this.wrongLetterClasses)
      }, 500)
    }
  }

  stepCompleted() {
    return this.termValue.length === this.selectedChars.length
  }

  goToNextStep() {
    if (this.stepCompleted()) {
      document.getElementById('next-step-button').click()
    }
  }
}
