import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static values = {
    selector: String,
  }

  connect() {
    setTimeout(() => {
      if (!this.hidden) this.focusElement()
    }, 0)
  }

  focus() {
    this.focusElement()
  }

  focusElement() {
    const element = this.hasSelectorValue
      ? this.element.querySelector(this.selectorValue)
      : this.element

    element?.focus()
  }

  get hidden() {
    return this.element.closest('.hidden,[hidden]')
  }
}
