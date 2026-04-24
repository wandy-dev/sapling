import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["step"]

  connect() {
    this.currentStep = 0
    this.showStep(0)
  }

  next() {
    if (this.validateCurrentStep()) {
      this.currentStep++
      this.showStep(this.currentStep)
    }
  }

  previous() {
    if (this.currentStep > 0) {
      this.currentStep--
      this.showStep(this.currentStep)
    }
  }

  showStep(index) {
    this.stepTargets.forEach((step, i) => {
      step.classList.toggle("is-hidden", i !== index)
    })

    this.updateButtons()
  }

  updateButtons() {
    const isFirst = this.currentStep === 0
    const isLast = this.currentStep === this.stepTargets.length - 1

    if (this.hasPreviousTarget) {
      this.previousTarget.hidden = isFirst
    }
    if (this.hasNextTarget) {
      this.nextTarget.hidden = isLast
    }
    if (this.hasSubmitTarget) {
      this.submitTarget.hidden = !isLast
    }
  }

  validateCurrentStep() {
    const currentStepEl = this.stepTargets[this.currentStep]
    const inputs = currentStepEl.querySelectorAll("input, select, textarea")
    let valid = true

    inputs.forEach(input => {
      if (!input.checkValidity()) {
        input.reportValidity()
        valid = false
      }
    })

    return valid
  }
}