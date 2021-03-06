import { Controller } from '@hotwired/stimulus'

const BACKSPACE = 8

// Connects to data-controller="auto-advance"
export default class extends Controller {
  connect () {
  }

  keydown (event) {
    const lastValue = event.target.value || ''
    const current = event.target

    if (event.keyCode === BACKSPACE) {
      if (lastValue.length === 0) {
        event.preventDefault()
        const previous = this.previousInput(current)
        previous.value = ''
        previous.focus()
        console.log(current.value, previous)
      }
    } else if (event.key.toLowerCase().match(/^[a-z]$/)) {
      event.preventDefault()
      current.value = event.key
      this.nextInput(current).focus()
    }
  }

  nextInput (current) {
    let found = null
    for (const input of this.inputs) {
      if (found) return input
      if (input === current) {
        found = input
      }
    }

    return current
  }

  previousInput (current) {
    let last = current
    let found = null
    for (const input of this.inputs) {
      if (input === current) {
        found = input
      }
      if (found) return last
      last = input
    }

    return current
  }

  get inputs () {
    return this.element.querySelectorAll('input[type=text]')
  }
}
