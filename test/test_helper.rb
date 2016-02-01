#!/usr/bin/env ruby
require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'bundler/setup'
require 'minitest/autorun'
require 'active_merchant'
require 'activemerchant_paybox_direct_plus'

ActiveMerchant::Billing::Base.mode = :test
