## Paybox Direct Plus

This is a implementation of Paybox Direct Plus for ActiveMerchant.
Paybox Direct Plus is a French payment solution allowing recurring payments, subscriptions, etc.

### Use and important information

You have to create a Paybox user profile for every user you want to charge :

    response = @gateway.create_payment_profile(@amount, @credit_card, { :user_reference => "YOUR_USER_REFERENCE" })

When creating a user profile, Paybox will do an authorization on the credit card. Thefore Paybox recommends that you give the same amount than your transaction
when registering a user, so that you can do a `capture` after.

The Paybox response contains the identifier `response.params["authorization"]` that may be saved in order to void or capture the transaction.

    @gateway.capture(@amount, response.params["authorization"], { :user_reference => "YOUR_USER_REFERENCE", :order_id => "ORDER_REFERENCE" })

Using the `purchase` method will do an authorization and a capture. Some banks requires some delay between 2 authorizations on the same card. So if you register
a profile then call `purchase` just after instead of `capture`, it may fail with some banks.

When registering a new user, you will get a credit card reference in the response you get from Paybox : `response.params["credit_card_reference"])`.

This is the reference you will have to add in the options when calling `purcharse` or `authorization` methods. You still have to pass a credit_card object but it will
only be used for the validation date and CVV number.

    @gateway.purchase(@amount, @credit_card, { :user_reference => "YOUR_USER_REFERENCE", :order_id => "ORDER_REFERENCE", :credit_card_reference => @credit_card_reference })


### Tests

Remote integrations tests using the Paybox tests logins and server are available and should always pass.

### Credits

The base of all this work is Donald Piret's great work on Paybox Direct Gateway implementation.

### Contact

Please don't hesitate to contact me if you have any question, any suggestion or if you found any bug.

