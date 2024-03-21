import { Controller } from '@hotwired/stimulus'
import React from 'react'
import { createRoot } from 'react-dom/client'

// Connects to data-controller="react"
export default class extends Controller {
  static values = {
    name: String,
    path: String,
    props: Object
  }

  root = null

  async connect() {
    const components = import.meta.glob('@/components/**/*.{jsx,tsx}')
    const component = await components[this.pathValue]()

    this.root = createRoot(this.element)
    this.root.render(React.createElement(component.default, this.propsValue))
  }

  disconnect() {
    this.root.unmount()
  }
}
