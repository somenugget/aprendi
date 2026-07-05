import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static activeAudio = null

  static values = {
    url: String,
  }

  disconnect() {
    this.constructor.stopActiveAudio()
  }

  play(event) {
    event.preventDefault()
    event.stopPropagation()

    this.constructor.stopActiveAudio()
    this.constructor.activeAudio = new Audio(this.urlValue)
    this.constructor.activeAudio.play()
  }

  static stopActiveAudio() {
    if (!this.activeAudio) return

    this.activeAudio.pause()
    this.activeAudio.currentTime = 0
    this.activeAudio = null
  }
}
