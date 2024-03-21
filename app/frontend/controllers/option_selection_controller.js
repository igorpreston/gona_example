import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['option', 'optionRow'] // Add 'optionRow' target

  connect() {
    this.updateOptionStates()
    this.optionTargets.forEach(option => option.addEventListener('change', this.toggleOption.bind(this)))
  }

  disconnect() {
    this.optionTargets.forEach(option => option.removeEventListener('change', this.toggleOption.bind(this)))
  }

  updateOptionStates() {
    const maxSelections = parseInt(this.data.get('maxSelections') || 1)
    const selectedOptions = this.optionTargets.filter(option => option.checked)

    this.optionTargets.forEach((option, index) => {
      const isOptionSelected = option.checked
      const isMaxSelectionsReached = selectedOptions.length >= maxSelections

      option.disabled = isMaxSelectionsReached && !isOptionSelected
      this.optionRowTargets[index].classList.toggle('opacity-30', isMaxSelectionsReached && !isOptionSelected)
    })
  }

  toggleOption(event) {
    this.updateOptionStates()
  }
}
