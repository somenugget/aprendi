import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static values = {
    url: String,
  }

  play(event) {
    event.preventDefault()
    event.stopPropagation()

    new Audio(this.urlValue).play()
  }
}
