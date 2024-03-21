import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ["star", "value"]

  connect() {
    this.valueTarget.value = this.data.get("value") || 0
    this.highlightStars()

    this.starTargets.forEach((star, index) => {
      star.addEventListener("mouseover", () => {
        this.highlightStars(index + 1)
      })

      star.addEventListener("mouseleave", () => {
        this.highlightStars()
      })
    })
  }

  highlightStars(value = this.value) {
    this.starTargets.forEach((star, index) => {
      if (index < value) {
        star.classList.remove("text-gray-200")
        star.classList.add("text-yellow-500")
      } else {
        star.classList.remove("text-yellow-500")
        star.classList.add("text-gray-200")
      }
    })
  }

  setRating(event) {
    this.value = parseInt(event.currentTarget.dataset.ratingValue)
    this.valueTarget.value = this.value
    this.highlightStars()
  }

  get value() {
    return parseInt(this.data.get("value"))
  }

  set value(value) {
    this.data.set("value", value)
  }
}
