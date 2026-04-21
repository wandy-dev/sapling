import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  toggle(event) {
    event.preventDefault()
    event.stopPropagation()
    this.element.classList.toggle("is-active")
  }

  hide(event) {
    if (!this.element.contains(event.target)) {
      this.element.classList.remove("is-active")
    }
  }

  connect() {
    this.hideHandler = this.hide.bind(this)
    document.addEventListener("click", this.hideHandler)
  }

  disconnect() {
    document.removeEventListener("click", this.hideHandler)
  }
}
