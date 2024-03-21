import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ["nav"]

  connect() {
    console.log("Hello, Stimulus!", this.element)
    console.log(this.navTarget)
  }

  toggle() {
    console.log('toggle')
    this.navTarget.classList.toggle("hidden")
  }
}
