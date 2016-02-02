require 'test_helper'

class RemotePayboxDirectTest < Minitest::Test
  def setup
    @gateway = ActiveMerchant::Billing::PayboxDirectPlusGateway.new(
      login:    '199988899',
      password: '1999888I'
    )

    @amount = 100
    @credit_card = credit_card('1111222233334444')

    @options = {
      order_id:       "REF#{Time.now.usec}",
      user_reference: "USER#{Time.now.usec}"
    }
  end

  def test_create_profile
    assert response = @gateway.subscriber_create(@amount, @credit_card, @options)
    assert response.success?
    assert_equal 'The transaction was approved', response.message
  end

  def test_create_profile_capture_and_void
    assert response = @gateway.subscriber_create(@amount, @credit_card, @options)
    assert response.success?

    credit_card_reference = response.params['porteur']
    assert !credit_card_reference.nil?

    assert capture = @gateway.subscriber_capture(@amount, response.authorization, @options)
    assert capture.success?

    assert void = @gateway.subscriber_void(@amount, capture.authorization, @options)
    assert_equal 'The transaction was approved', void.message
    assert void.success?
  end

  def test_create_profile_and_purchase
    assert response = @gateway.subscriber_create(@amount, @credit_card, @options)
    assert response.success?

    credit_card_reference = response.params['porteur']
    assert !credit_card_reference.nil?

    @credit_card.number = nil
    @credit_card.first_name = nil
    @credit_card.last_name = nil

    assert success = @gateway.subscriber_purchase(@amount, @credit_card, @options.merge(credit_card_reference: credit_card_reference))
    assert success.success?
    assert_equal 'The transaction was approved', success.message
  end

  def test_create_profile_capture_and_refund
    assert response = @gateway.subscriber_create(@amount, @credit_card, @options)
    assert response.success?

    credit_card_reference = response.params['porteur']
    assert !credit_card_reference.nil?

    assert capture = @gateway.subscriber_capture(@amount, response.authorization, @options)
    assert capture.success?

    assert refund = @gateway.subscriber_refund(@amount, capture.authorization, @options)
    assert_equal 'The transaction was approved', refund.message
    assert refund.success?
  end

  def test_failed_capture
    assert response = @gateway.subscriber_capture(@amount, '', order_id: '1', user_reference: 'pipomolo')
    assert !response.success?
    assert_equal 'Invalid data', response.message
  end

  private

  def default_expiration_date
    @default_expiration_date ||= Date.new((Time.now.year + 1), 9, 30)
  end

  def credit_card(number = '4242424242424242', options = {})
    defaults = {
      number: number,
      month: default_expiration_date.month,
      year: default_expiration_date.year,
      first_name: 'Longbob',
      last_name: 'Longsen',
      verification_value: options[:verification_value] || '123',
      brand: 'visa'
    }.update(options)

    ActiveMerchant::Billing::CreditCard.new(defaults)
  end
end
