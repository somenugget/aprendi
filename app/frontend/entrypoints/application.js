// eslint-disable-next-line import/no-extraneous-dependencies
import * as Turbo from '@hotwired/turbo'
import { initFlowbite } from 'flowbite'

import '../controllers'

import '../helpers/registerServiceWorker'

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
