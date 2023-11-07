// Import and register all your controllers from the importmap under controllers/*

import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }

import { registerControllers } from 'stimulus-vite-helpers'

const controllers = import.meta.globEager('./**/*_controller.js')
registerControllers(application, controllers)
