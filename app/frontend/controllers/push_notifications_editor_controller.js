import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['checkbox', 'toggleable', 'disabledHint']

  static values = {
    serverKey: String,
  }

  connect() {
    if (window.Notification.permission === 'denied') {
      this.showDisabledNotification()
    }

    if (this.checkboxTarget.checked) {
      this.subscribe()
    }
  }

  toggle() {
    if (this.checkboxTarget.checked) {
      window.Notification.requestPermission().then((permission) => {
        if (permission === 'denied') {
          this.showDisabledNotification()
        }

        if (permission === 'granted') {
          this.subscribe()
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

  subscribe() {
    return navigator.serviceWorker.getRegistration().then((registration) => {
      return registration.pushManager.getSubscription().then((subscription) => {
        if (!subscription) {
          registration.pushManager.subscribe({
            userVisibleOnly: true,
            applicationServerKey: this.serverKeyWithoutPadding,
          })
        }
      })
    })
  }

  get serverKeyWithoutPadding() {
    return this.serverKeyValue.replace(/=+$/, '')
  }
}
