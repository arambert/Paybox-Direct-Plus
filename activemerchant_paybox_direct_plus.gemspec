lib = File.expand_path('..', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lib/version'

Gem::Specification.new do |s|
  s.name = 'activemerchant_paybox_direct_plus'
  s.version = ActivemerchantPayboxDirectPlus::VERSION

  s.description = 'Paybox Direct Plus ActiveMerchant Billing Gateway implementation'
  s.summary = 'Paybox Direct Plus for ActiveMerchant'

  s.authors = %w(donaldpiret arambert slainer68 TiteiKo)
  s.email = 'nospam@nospam.com'

  s.extra_rdoc_files = [
    'LICENSE.txt',
    'README.md'
  ]
  s.files = [
    'Gemfile',
    'Gemfile.lock',
    'LICENSE.txt',
    'README.markdown',
    'Rakefile',
    'VERSION',
    'activemerchant_paybox_direct_plus.gemspec',
    'lib/activemerchant_paybox_direct_plus.rb',
    'test/fixtures.yml',
    'test/remote/gateways/remote_paybox_direct_plus_test.rb',
    'test/test_helper.rb'
  ]

  s.homepage = 'https://github.com/arambert/Paybox-Direct-Plus'
  s.licenses = ['MIT']
  s.require_paths = ['lib']

  s.add_dependency 'activemerchant', '~> 1'

  s.add_development_dependency 'minitest', '>= 0'
  s.add_development_dependency 'bundler', '>= 0'
  s.add_development_dependency 'simplecov', '>= 0'
  s.add_development_dependency 'bundler', '~> 1.7'
  s.add_development_dependency 'rake', '~> 10'
end
