// app/javascript/controllers/dark_mode_toggle_controller.js
import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['toggle', 'sunIcon', 'moonIcon']

  static values = { theme: String }

  connect() {
    const savedTheme = localStorage.getItem('theme')

    this.themeValue = ['light', 'dark'].includes(savedTheme)
      ? savedTheme
      : 'light'

    this.applyTheme()

    window
      .matchMedia('(prefers-color-scheme: dark)')
      .addEventListener('change', (e) => {
        if (!localStorage.getItem('theme')) {
          this.themeValue = e.matches ? 'dark' : 'light'
          this.applyTheme()
        }
      })
  }

  toggle() {
    this.themeValue = this.themeValue === 'light' ? 'dark' : 'light'
    this.applyTheme()

    localStorage.setItem('theme', this.themeValue)
  }

  applyTheme() {
    if (this.themeValue === 'dark') {
      document.documentElement.classList.add('dark')
    } else {
      document.documentElement.classList.remove('dark')
    }
  }
}
