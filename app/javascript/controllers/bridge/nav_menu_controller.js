import { Controller } from "@hotwired/stimulus"
import { BridgeElement } from "@hotwired/strada"

// Connects to data-controller="bridge--nav-menu"
export default class extends Controller {
  static component = "nav-menu"
  static targets = ["item"]

  connect() {
    this.element.classList.add("is-hidden")

    const items = this.itemTargets.map(item => new BridgeElement(item))
      .map((item, index) => ({ title: item.title, index }));

    this.send("connect", { items }, message => {
      const selectedIndex = message.data.selectedIndex
      const selectedItem = new BridgeElement(this.itemTargets[selectedIndex])

      selectedItem.click()
    })
  }

  disconnect() {
    this.send("disconnect")
  }
}
