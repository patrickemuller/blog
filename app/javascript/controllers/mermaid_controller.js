import { Controller } from "@hotwired/stimulus"

let diagramCount = 0

// Connects to data-controller="mermaid"
// Renders every <pre class="mermaid"> inside the element and re-renders when
// the dark theme is toggled (the `dark` class on <html>).
export default class extends Controller {
  async connect() {
    this.diagrams = Array.from(this.element.querySelectorAll("pre.mermaid"))
    if (this.diagrams.length === 0) return

    // Keep the source: rendering replaces it with an SVG, and Turbo's page
    // cache can hand us an already-rendered element on restore.
    this.diagrams.forEach((pre) => { pre.dataset.source ??= pre.textContent })

    this.mermaid = (await import("mermaid")).default
    this.observer = new MutationObserver(() => this.render())
    this.observer.observe(document.documentElement, { attributes: true, attributeFilter: ["class"] })
    this.render()
  }

  disconnect() {
    this.observer?.disconnect()
  }

  async render() {
    const theme = document.documentElement.classList.contains("dark") ? "dark" : "default"
    if (theme === this.theme) return
    this.theme = theme

    this.mermaid.initialize({ startOnLoad: false, theme })
    for (const pre of this.diagrams) {
      try {
        const { svg } = await this.mermaid.render(`mermaid-${++diagramCount}`, pre.dataset.source)
        pre.innerHTML = svg
      } catch (error) {
        pre.textContent = pre.dataset.source
        console.error("Mermaid failed to render diagram", error)
      }
    }
  }
}
