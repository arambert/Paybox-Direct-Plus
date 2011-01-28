## Paybox Direct Plus

This is a implementation of Paybox Direct Plus for ActiveMerchant Billing Gateway.
Paybox Direct Plus is a french payment solution allowing recurring payments, subscriptions etc...

### Creditcard Object

In order to use Paybox Direct Plus, you have to add two attributes to your Creditcard model:

* gateway_payment_profile_id : this attribute's value will be returned by Paybox during the registration step. It will replace the creditcard number for the next payments.
* gateway_customer_profile_id : this is a unique customer identifier defined by the seller (you). If a customer uses several creditcards, he should have one unique gateway_customer_profile_id per creditcard.

These attributes must be stored (in your database) in order to be able to use the subscription option in Paybox Direct Plus.

## Paybox Direct

This should also work with a simple Paybox Direct use (the "Plus" in Paybox Direct Plus is the option allowing recurring payments)

## Credits

This is a fork of Donald Piret's great work on Paybox Direct.

## Contact

Please don't hesitate to contact me if you have any question, any suggestion or if you found any bug.