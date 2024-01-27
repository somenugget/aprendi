// eslint-disable-next-line import/no-extraneous-dependencies
import * as Turbo from '@hotwired/turbo'
import { initFlowbite } from 'flowbite'

import '../controllers'

Turbo.start()

document.addEventListener('turbo:load', () => {
  initFlowbite()
})

document.addEventListener('turbo:before-fetch-request', (event) => {
  try {
    // eslint-disable-next-line no-param-reassign
    event.detail.fetchOptions.headers['X-Time-Zone'] =
      Intl.DateTimeFormat().resolvedOptions().timeZone
  } catch (e) {
    console.error(e)
  }
})

const registerServiceWorker = async () => {
  if ('serviceWorker' in navigator) {
    try {
      const registration = await navigator.serviceWorker.register(
        '/service-worker.js',
        {
          scope: '/',
        },
      )
      if (registration.installing) {
        console.log('Service worker installing')
      } else if (registration.waiting) {
        console.log('Service worker installed')
      } else if (registration.active) {
        console.log('Service worker active')
      }
    } catch (error) {
      console.error(`Registration failed with ${error}`)
    }
  }
}

// …

registerServiceWorker()
