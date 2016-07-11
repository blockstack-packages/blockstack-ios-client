Pod::Spec.new do |s|
  s.name        = 'BlockstackClient'
  s.version     = '1.0'
  s.summary     = 'iOS client for blockstack-server.'
  s.homepage    = 'https://github.com/blockstack/blockstack-ios-client'
  s.license     = { :type => "MIT" }
  s.authors     = { 'itsProf' => 'jorge@profapps.co' }
  s.requires_arc = true
  s.osx.deployment_target = '10.11'
  s.ios.deployment_target = '9.3'
  s.watchos.deployment_target = '2.2'
  s.tvos.deployment_target = '9.2'
  s.source   = { :git => 'https://github.com/blockstack/blockstack-ios-client.git', :tag => s.version }
  s.source_files = 'BlockstackClient'
  s.dependency 'CoreBitcoin'
  s.dependency 'AFNetworking'
end
