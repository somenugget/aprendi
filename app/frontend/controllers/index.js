// Import and register all your controllers from the importmap under controllers/*

import { Application } from '@hotwired/stimulus'

import { registerControllers } from 'stimulus-vite-helpers'

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus = application

// eslint-disable-next-line import/prefer-default-export
export { application }

const controllers = import.meta.glob('./**/*_controller.js', { eager: true })
registerControllers(application, controllers)
