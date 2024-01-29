import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['checkbox', 'toggleable', 'disabledHint']

  connect() {
    if (window.Notification.permission === 'denied') {
      this.showDisabledNotification()
    }
  }

  toggle() {
    if (this.checkboxTarget.checked) {
      window.Notification.requestPermission().then((permission) => {
        if (permission === 'denied') {
          this.showDisabledNotification()
        }
      })
    }
  }

  showDisabledNotification() {
    this.checkboxTarget.disabled = true
    this.checkboxTarget.checked = false
    this.toggleableTarget.classList.remove('cursor-pointer')
    this.disabledHintTarget.classList.remove('hidden')
  }
}
