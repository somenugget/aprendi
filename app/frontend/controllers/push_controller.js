/* eslint-disable no-console */
import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static values = {
    serverKey: String,
  }

  connect() {
    this.getSubscription().then((subscription) => {
      this.saveSubscription(subscription)
    })
  }

  getSubscription() {
    return navigator.serviceWorker.getRegistration().then((registration) =>
      registration.pushManager.getSubscription().then((subscription) => {
        if (subscription) {
          return subscription
        }

        return this.subscribe(registration)
      }),
    )
  }

  subscribe(registration) {
    return registration.pushManager.subscribe({
      userVisibleOnly: true,
      applicationServerKey: this.serverKeyWithoutPadding,
    })
  }

  saveSubscription(subscription) {
    // Extract necessary subscription data
    const { endpoint } = subscription
    const p256dh = btoa(
      String.fromCharCode.apply(
        null,
        new Uint8Array(subscription.getKey('p256dh')),
      ),
    )
    const auth = btoa(
      String.fromCharCode.apply(
        null,
        new Uint8Array(subscription.getKey('auth')),
      ),
    )

    // Send the subscription data to the server
    fetch('/push_subscriptions', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Accept: 'application/json',
        'X-CSRF-Token': document
          .querySelector('meta[name="csrf-token"]')
          .getAttribute('content'),
      },
      body: JSON.stringify({
        endpoint,
        p256dh,
        auth,
        user_agent: navigator.userAgent,
      }),
    })
      .then((response) => {
        if (response.ok) {
          console.log('Subscription successfully saved on the server.')
        } else {
          console.error('Error saving subscription on the server.')
        }
      })
      .catch((error) => {
        console.error('Error sending subscription to the server:', error)
      })
  }

  get serverKeyWithoutPadding() {
    return this.serverKeyValue.replace(/=+$/, '')
  }
}
