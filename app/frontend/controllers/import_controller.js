import { Controller } from '@hotwired/stimulus'
import { useDebounce } from 'stimulus-use'

export default class extends Controller {
  static targets = ['termsList', 'parsingIndicator']

  static values = { parsing: Boolean }

  static debounces = ['parse']

  connect() {
    this.parsingStartTime = null

    useDebounce(this, {
      wait: 1000,
    })

    this.element.addEventListener('turbo:submit-start', () => {
      // show indicator a bit later in case parsing will be really fast
      this.submitStartTimeoutId = setTimeout(() => {
        this.parsingStartTime = new Date()
        this.parsingValue = true
      }, 500)
    })

    this.element.addEventListener('turbo:submit-end', () => {
      if (!this.parsingValue) {
        return clearTimeout(this.submitStartTimeoutId)
      }

      // Wait at least 1 second before hiding the parsing indicator
      return setTimeout(
        () => {
          this.parsingValue = false
        },
        this.parsingStartTime.getTime() < new Date() - 1000 ? 0 : 1000,
      )
    })
  }

  parse() {
    this.element.requestSubmit()
  }

  parsingValueChanged() {
    if (this.parsingValue) {
      this.parsingIndicatorTarget.classList.remove('invisible')
    } else {
      this.parsingIndicatorTarget.classList.add('invisible')
    }
  }
}
