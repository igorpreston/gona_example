import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.stripe = Stripe(this.element.getAttribute('data-stripe-publishable-key'), {
      stripeAccount: this.element.getAttribute('data-stripe-account')
    });

    this.initializeElements(this.element.getAttribute('data-stripe-client-secret'));
    this.checkStatus();
    this.element.addEventListener("submit", this.handleSubmit.bind(this));
  }

  async initializeElements(clientSecret) {
    this.elements = this.stripe.elements({ clientSecret });
    this.paymentElement = this.elements.create("payment");
    this.paymentElement.mount("#payment-element");
  }

  async handleSubmit(e) {
    e.preventDefault();
    this.setLoading(true);

    const { error, paymentIntent } = await this.stripe.confirmPayment({
      elements: this.elements,
      confirmParams: {
        return_url: this.element.getAttribute('data-return-url')
      }
    });

    if (error) {
      this.showMessage(error.message);
    } else {
      this.handlePaymentIntentStatus(paymentIntent);
    }

    this.setLoading(false);
  }

  async checkStatus() {
    const clientSecret = new URLSearchParams(window.location.search).get("payment_intent_client_secret");
    if (!clientSecret) return;

    const { paymentIntent } = await this.stripe.retrievePaymentIntent(clientSecret);
    this.handlePaymentIntentStatus(paymentIntent);
  }

  handlePaymentIntentStatus(paymentIntent) {
    switch (paymentIntent.status) {
      case "succeeded":
        this.showMessage("Payment succeeded!");
        break;
      case "processing":
        this.showMessage("Your payment is processing.");
        break;
      case "requires_payment_method":
        this.showMessage("Your payment was not successful, please try again.");
        break;
      default:
        this.showMessage("Something went wrong.");
        break;
    }
  }

  showMessage(messageText) {
    const messageContainer = document.querySelector("#payment-message");
    messageContainer.classList.remove("hidden");
    messageContainer.textContent = messageText;
  }

  setLoading(isLoading) {
    const submitButton = document.querySelector("#submit");
    const spinner = document.querySelector("#spinner");
    const buttonText = document.querySelector("#button-text");

    submitButton.disabled = isLoading;
    spinner.classList.toggle("hidden", !isLoading);
    buttonText.classList.toggle("hidden", isLoading);
  }
}
