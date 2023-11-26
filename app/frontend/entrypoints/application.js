// eslint-disable-next-line import/no-extraneous-dependencies
import * as Turbo from '@hotwired/turbo'
import { initFlowbite } from 'flowbite'

import '../controllers'

Turbo.start()

document.addEventListener('turbo:load', () => {
  initFlowbite()
})

// import ActiveStorage from '@rails/activestorage'
// ActiveStorage.start()
//
// // Import all channels.
// const channels = import.meta.globEager('./**/*_channel.js')

// Example: Import a stylesheet in app/frontend/index.css
// import '~/index.css'
