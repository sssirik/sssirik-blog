import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    document.addEventListener('scroll', () => {
      this.element.querySelectorAll('[data-parallax-speed]').forEach(el => {
        const speed = el.dataset.parallaxSpeed;
        const yPos = window.scrollY * speed;
        el.style.transform = `translate3d(0, ${yPos}px, 0)`;
      });
    });
  }
}