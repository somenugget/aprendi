import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['failed', 'cell', 'letter', 'nextStep']

  static classes = ['wrongLetter', 'correctLetter']

  static values = {
    term: Array,
  }

  connect() {
    this.selectedChars = []
  }

  select(e) {
    const currentTarget = e.currentTarget

    this.selectChar(e.params.char, () => {
      currentTarget.setAttribute('disabled', 'disabled')
    })
  }

  selectChar(char, successCallback) {
    const currentCell = this.currentCell()
    const currentChar = this.currentChar()

    if (this.normalizeString(char) === this.normalizeString(currentChar)) {
      currentCell.classList.add(...this.correctLetterClasses)
      currentCell.innerHTML = currentChar
      this.selectedChars.push(currentChar)

      if (this.stepCompleted()) {
        this.nextStepTarget.classList.remove('hidden')
        this.nextStepTarget.classList.add('flex')
      }

      successCallback()
    } else {
      currentCell.classList.add(...this.wrongLetterClasses)

      this.failedTarget.value = 'true'
      setTimeout(() => {
        currentCell.classList.remove(...this.wrongLetterClasses)
      }, 500)
    }
  }

  currentCell() {
    return this.cellTargets[this.selectedChars.length]
  }

  currentChar() {
    return this.termValue[this.selectedChars.length]
  }

  stepCompleted() {
    return this.termValue.length === this.selectedChars.length
  }

  goToNextStep() {
    if (this.stepCompleted()) {
      document.getElementById('next-step-button').click()
    }
  }

  selectWithKeyboard(e) {
    const key = e.key.toLowerCase()
    const keyCode = e.keyCode
    const isUppercaseLetter = keyCode >= 65 && keyCode <= 90
    const isLowercaseLetter = keyCode >= 97 && keyCode <= 122

    if (!isUppercaseLetter && !isLowercaseLetter) {
      return
    }

    const availableLetters = this.letterTargets.filter(
      (target) => !target.disabled,
    )

    const exactMatchLetter = availableLetters.find(
      (target) => target.dataset.char.toLowerCase() === key,
    )
    const normalizedKey = this.normalizeString(key)
    const normalizedMatchLetter = availableLetters.find(
      (target) => this.normalizeString(target.dataset.char) === normalizedKey,
    )

    this.selectChar(key, () => {
      if (exactMatchLetter) {
        exactMatchLetter.setAttribute('disabled', 'disabled')
      } else if (normalizedMatchLetter) {
        normalizedMatchLetter.setAttribute('disabled', 'disabled')
      }
    })
  }

  normalizeString(string) {
    return string
      .normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '')
      .toLowerCase()
  }
}
