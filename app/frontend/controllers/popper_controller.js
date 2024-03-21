import { Controller } from '@hotwired/stimulus'
import { createPopper } from '@popperjs/core'

// Connects to data-controller="popper"
export default class extends Controller {
  static targets = ['element', 'tooltip']
  static values = {
    placement: { type: String, default: 'top' },
    offset: { type: Array, default: [0, 4] }
  }

  connect() {
    // Create a new Popper instance
    this.popperInstance = createPopper(this.elementTarget, this.tooltipTarget, {
      placement: this.placementValue,
      modifiers: [
        {
          name: 'offset',
          options: {
            offset: this.offsetValue,
            fallbackPlacements: ['top', 'bottom', 'left', 'right'],
            offset: [0, 4],
            showEvent: { type: String, default: 'mouseenter' },
            hideEvent: { type: String, default: 'mouseleave' }
          }
        }
      ]
    })
  }

  show(event) {
    this.tooltipTarget.classList.remove('hidden')
    this.tooltipTarget.classList.add('block')
    this.popperInstance.update()
  }

  hide(event) {
    this.tooltipTarget.classList.remove('block')
    this.tooltipTarget.classList.add('hidden')
    this.popperInstance.update()
  }

  disconnect() {
    if (this.popperInstance) {
      this.popperInstance.destroy()
    }
  }
}
