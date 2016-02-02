require 'active_merchant'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    class PayboxDirectPlusGateway < PayboxDirectGateway
      # Payment API Version
      API_VERSION = '00104'

      # Transactions hash
      TRANSACTIONS = {
        authorization:            '00001',
        capture:                  '00002',
        purchase:                 '00003',
        unreferenced_credit:      '00004',
        void:                     '00005',
        refund:                   '00014',
        subscriber_authorization: '00051',
        subscriber_capture:       '00052',
        subscriber_purchase:      '00053',
        subscriber_credit:        '00054',
        subscriber_refund:        '00014',
        subscriber_void:          '00055',
        subscriber_create:        '00056',
        subscriber_update:        '00057',
        subscriber_destroy:       '00058'
      }

      ALREADY_EXISTING_PROFILE_CODES = ['00016']
      UNKNOWN_PROFILE_CODES = ['00017']
      FRAUD_CODES = %w(00102 00104 00105 00134 00138 00141 00143 00156 00157 00159)

      # The name of the gateway
      self.display_name = 'Paybox Direct Plus'

      def payment_profiles_supported?
        true
      end

      def subscriber_authorize(money, creditcard, options = {})
        requires!(options, :user_reference)
        post = {}
        add_invoice(post, options)
        add_creditcard(post, creditcard, options)
        add_user_reference(post, options)
        add_amount(post, money, options)
        commit('subscriber_authorization', money, post)
      end

      def subscriber_purchase(money, creditcard, options = {})
        requires!(options, :credit_card_reference, :user_reference)
        post = {}
        add_invoice(post, options)
        add_creditcard(post, creditcard, options)
        add_user_reference(post, options)
        add_amount(post, money, options)
        commit('subscriber_purchase', money, post)
      end

      def subscriber_capture(money, authorization, options = {})
        requires!(options, :order_id, :user_reference)
        post = {}
        add_invoice(post, options)
        add_reference(post, authorization)
        add_user_reference(post, options)
        add_amount(post, money, options)
        commit('subscriber_capture', money, post)
      end

      def subscriber_void(money, authorization, options = {})
        requires!(options, :order_id, :user_reference)
        post = {}
        add_invoice(post, options)
        add_reference(post, authorization)
        add_user_reference(post, options)
        add_amount(post, money, options)
        post[:porteur] = '000000000000000'
        post[:dateval] = '0000'
        commit('subscriber_void', money, post)
      end

      def subscriber_credit(money, identification, options = {})
        post = {}
        add_invoice(post, options)
        add_reference(post, identification)
        add_user_reference(post, options)
        add_amount(post, money, options)
        commit('subscriber_credit', money, post)
      end

      def subscriber_refund(money, authorization, options = {})
        post = {}
        add_invoice(post, options)
        add_reference(post, authorization)
        add_user_reference(post, options)
        add_amount(post, money, options)
        commit('subscriber_refund', money, post)
      end

      def subscriber_create(money, creditcard, options = {})
        requires!(options, :user_reference)
        post = {}
        add_creditcard(post, creditcard, options)
        add_user_reference(post, options)
        add_amount(post, money, options)
        commit('subscriber_create', money, post)
      end

      def subscriber_update(money, creditcard, options = {})
        post = {}
        add_creditcard(post, creditcard, options)
        add_user_reference(post, options)
        add_amount(post, money, options)
        commit('subscriber_update', money, post)
      end

      def subscriber_destroy(money, options)
        post = {}
        add_user_reference(post, options)
        add_amount(post, money, options)
        commit('subscriber_destroy', money, post)
      end

      private

      def add_creditcard(post, creditcard, options = {})
        post[:porteur] = options[:credit_card_reference] || creditcard.number
        post[:dateval] = expdate(creditcard)
        post[:cvv] = creditcard.verification_value if creditcard.verification_value?
      end

      def add_user_reference(post, options)
        post[:refabonne] = options[:user_reference]
      end

      def fraud_review?(response)
        FRAUD_CODES.include?(response[:codereponse])
      end

      def unknown_customer_profile?(response)
        UNKNOWN_PROFILE_CODES.include?(response[:codereponse])
      end

      def already_existing_customer_profile?(response)
        ALREADY_EXISTING_PROFILE_CODES.include?(response[:codereponse])
      end

      def post_data(action, parameters = {})
        parameters.update(
          version:     API_VERSION,
          type:        TRANSACTIONS[action.to_sym],
          dateq:       Time.now.strftime('%d%m%Y%H%M%S'),
          numquestion: unique_id(parameters[:order_id]),
          site:        @options[:login].to_s[0, 7],
          rang:        @options[:rang] || @options[:login].to_s[7..-1],
          cle:         @options[:password],
          pays:        '',
          archivage:   parameters[:reference]
        )

        parameters.collect { |key, value| "#{key.to_s.upcase}=#{CGI.escape(value.to_s)}" }.join('&')
      end
    end
  end
end
