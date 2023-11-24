import { Controller } from '@hotwired/stimulus'
import { useDebounce } from 'stimulus-use'

export default class extends Controller {
  static debounces = ['save']

  connect() {
    useDebounce(this, {
      wait: 2000,
    })
  }

  save() {
    this.element.requestSubmit()
  }
}
