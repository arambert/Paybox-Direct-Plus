## Paybox Direct Plus

This is a implementation of Paybox Direct Plus for ActiveMerchant.
Paybox Direct Plus is a French payment solution allowing recurring payments, subscriptions, etc.

### Setup the gateway

```ruby
gateway = ActiveMerchant::Billing::PayboxDirectPlusGateway.new(
  login:    '199988899',
  password: '1999888I'
)
```
### Subscribed user functionalities

Create a user profile:

```ruby
response = gateway.subscriber_create(amount, active_merchant_credit_card, user_reference: 'YOUR_USER_REFERENCE')
response.success?           # check if called succeeded
response.authorization      # authorization number, to be used for capture / void / refund
response.params['porteur']  # credit card reference, to be saved to use with the user reference for future purchases
```

When creating a user profile, Paybox will do an authorization on the credit card.
Paybox recommends that you give the same amount than your transaction so you can simple capture it later.

If you don't know yet how much you'll have to charge the client, you can also send an amount of 0.

After your client is subscribed, you will be able to use several other operations:

```ruby
credit_card = ActiveMerchant::Billing::CreditCard.new(
  last_name:          client_cc.last_name,
  first_name:         client_cc.first_name,
  verification_value: client_cc.verification_value,
  year:               client_cc.expires_on.year,
  month:              client_cc.expires_on.month
) # notice the absence of credit card number here

purchase = gateway.subscriber_purchase(
  amount, credit_card,
  user_reference:  'YOUR_USER_REFERENCE',
  order_id:        'ORDER_REFERENCE',
  credit_card_reference: subscriber_create_response.params['porteur']
) # authorize + capture in one call

authorize = gateway.subscriber_authorize(
  amount, credit_card,
  user_reference:        'YOUR_USER_REFERENCE',
  order_id:              'ORDER_REFERENCE',
  credit_card_reference: subscriber_create_response.params['porteur']
)

capture = gateway.subscriber_capture(
  amount, authorize.authorization,
  user_reference: 'YOUR_USER_REFERENCE',
  order_id:       'ORDER_REFERENCE'
)

refund = gateway.subscriber_refund(
  amount, authorize.authorization,
  user_reference: 'YOUR_USER_REFERENCE',
  order_id:       'ORDER_REFERENCE'
)

void = gateway.subscriber_void(
  amount, authorize.authorization,
  user_reference: 'YOUR_USER_REFERENCE',
  order_id:       'ORDER_REFERENCE'
)
```

Using the `subscriber_purchase` method will do an authorization and a capture. Some banks requires some delay between 2
authorizations on the same card. So, if you register a profile then call `subscriber_purchase` just after instead of
`subscriber_capture`, it may fail with some banks.

### Non subscribed user functionalities

The gateway inherits [Donal Piret's Paybox Direct Gateway](https://github.com/activemerchant/active_merchant/blob/master/lib/active_merchant/billing/gateways/paybox_direct.rb),
so all methods of that gateway are accessible.

### Compatibility

For Ruby 1.8, use version 0.1.0

For Ruby 1.9, use version 0.2.0

For Ruby 2.0+, use latest version ~>1.0

### Tests

Remote integrations tests using the Paybox tests logins and server are available and should always pass.

```
bundle install
bundle exec rake test
```

### Credits

The base of all this work is Donald Piret's great work on Paybox Direct Gateway implementation.

### Contact

Please don't hesitate to contact me if you have any question, any suggestion or if you found any bug.
