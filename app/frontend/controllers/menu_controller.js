import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['tab'];

  connect() {
    this.scrollHandler = this.highlightActiveTab.bind(this);
    window.addEventListener('scroll', this.scrollHandler);

    this.tabTargets.forEach((tab) => {
      tab.addEventListener('click', () => {
        this.highlightTab(tab);
      });
    });
  }

  disconnect() {
    window.removeEventListener('scroll', this.scrollHandler);
    this.tabTargets.forEach((tab) => {
      tab.removeEventListener('click', () => {
        this.highlightTab(tab);
      });
    });
  }

  highlightActiveTab() {
    const scrollPosition = window.scrollY;

    this.tabTargets.forEach((tab) => {
      const section = document.getElementById(tab.dataset.category);
      if (!section) return;

      const sectionTop = section.offsetTop - 100;
      const sectionBottom = sectionTop + section.clientHeight;

      if (scrollPosition >= sectionTop && scrollPosition < sectionBottom) {
        this.highlightTab(tab);
      }
    });
  }

  highlightTab(tab) {
    this.tabTargets.forEach((t) => {
      if (t === tab) {
        t.classList.add('bg-white', 'text-gray-900');
        t.classList.remove('text-gray-500', 'hover:text-gray-900');
      } else {
        t.classList.remove('bg-white', 'text-gray-900');
        t.classList.add('text-gray-500', 'hover:text-gray-900');
      }
    });
  }
}
