module ActiveMerchant
  module Billing
    module StripeGatewayDecorator
      private

      def headers(options = {})
        headers = super
        key = options[:key] || @api_key
        idempotency_key = options[:idempotency_key]

        headers = {
          'Authorization' => 'Basic ' + Base64.strict_encode64(key.to_s + ':'),
          'User-Agent' => "Stripe/v1 ActiveMerchantBindings/#{ActiveMerchant::VERSION}",
          'Stripe-Version' => api_version(options),
          'X-Stripe-Client-User-Agent' => stripe_client_user_agent(options),
          'X-Stripe-Client-User-Metadata' => {:ip => options[:ip]}.to_json
        }
        headers['Idempotency-Key'] = idempotency_key if idempotency_key
        headers['Stripe-Account'] = options[:stripe_account] if options[:stripe_account]
        headers
      end

      def add_customer_data(post, options)
        super
        post[:payment_user_agent] = "SpreeGateway/#{SpreeGateway.version}"
      end
    end
  end
end

ActiveMerchant::Billing::StripeGateway.prepend(ActiveMerchant::Billing::StripeGatewayDecorator)
