import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "feedback"]

  connect() {
    this.debouncedCheck = this.debouncedCheck.bind(this)
  }

  initialize() {
    this.xhr = null
  }

  check() {
    if (this.xhr && this.xhr.state() === "pending") {
      this.xhr.abort()
    }

    this.debouncedCheck()
  }

  debouncedCheck() {
    clearTimeout(this._timeout)
    this._timeout = setTimeout(() => this.performCheck(), 400)
  }

  async performCheck() {
    const value = this.inputTarget.value.toLowerCase()

    if (!value || value.length < 3) {
      this.clearFeedback()
      return
    }

    if (/(^[-]|[-]$)/.test(value)) {
      this.showFeedback("cannot start or end with hyphen", false)
      return
    }

    if (!/^[a-z0-9][a-z0-9-]*[a-z0-9]$/.test(value)) {
      this.showFeedback("only lowercase letters, numbers, and hyphens allowed", false)
      return
    }

    this.showFeedback("checking...", null)

    try {
      const response = await fetch(`http://api.${window.location.host}/api/v1/communities?community_address=${encodeURIComponent(value)}`)
      const data = await response.json()

      if (data.available) {
        this.showFeedback("available", true)
      } else {
        this.showFeedback("already taken", false)
      }
    } catch (error) {
      if (error.message !== "Request aborted") {
        this.clearFeedback()
      }
    }
  }

  showFeedback(message, isValid) {
    this.feedbackTarget.textContent = message
    this.feedbackTarget.className = `help ${isValid ? "is-success" : "is-danger"}`
  }

  clearFeedback() {
    this.feedbackTarget.textContent = ""
    this.feedbackTarget.className = "help"
  }
}
