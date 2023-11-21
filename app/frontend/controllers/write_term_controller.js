import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  submit() {
    document.getElementById('next-step-button').click()
  }
}
