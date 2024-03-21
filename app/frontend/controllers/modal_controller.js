import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]
  scrollPosition = 0;  // Property to store the scroll position

  // Closes the modal
  close(e) {
    e.preventDefault();

    // Get the turbo-frame element
    const turboFrame = document.querySelector('#modal');

    // Clear the content inside the turbo-frame
    if (turboFrame) {
      turboFrame.innerHTML = '';
    }

    // Restore the scroll position
    window.scrollTo(0, this.scrollPosition);

    // Remove overflow classes
    this.removeOverflow();

    // Re-enable scrolling on touch devices
    document.ontouchmove = function (e) {
      return true;
    };
  }

  // Connects the controller
  connect() {
    // Save the current scroll position
    this.scrollPosition = window.scrollY;

    // Add overflow classes to prevent background scrolling
    this.addOverflow();

    // Prevent scrolling on touch devices
    document.ontouchmove = function (e) {
      e.preventDefault();
    };

    // Additional setup if necessary...
  }

  // Disconnects the controller
  disconnect() {
    // Restore the scroll position
    window.scrollTo(0, this.scrollPosition);

    // Remove overflow classes
    this.removeOverflow();

    // Re-enable scrolling on touch devices
    document.ontouchmove = function (e) {
      return true;
    };

    // Additional teardown if necessary...
  }

  // Adds overflow classes
  addOverflow() {
    document.documentElement.classList.add('overflow-y-hidden');
    document.body.classList.add('overflow-hidden');
  }

  // Removes overflow classes
  removeOverflow() {
    document.documentElement.classList.remove('overflow-y-hidden');
    document.body.classList.remove('overflow-hidden');
  }

  // Finds the modal target element
  get modalTarget() {
    return this.targets.find("modal");
  }
}
