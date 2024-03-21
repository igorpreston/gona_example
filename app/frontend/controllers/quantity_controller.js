import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['value']

  connect() {
    this.valueTarget.addEventListener("change", () => alert('changed'))
  }

  increment() {
    this.valueTarget.stepUp()
  }

  decrement() {
    this.valueTarget.stepDown()
  }
}
