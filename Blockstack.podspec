Pod::Spec.new do |s|
  s.name        = 'Blockstack'
  s.version     = '0.0.14'
  s.summary     = 'iOS client for blockstack-server.'
  s.homepage    = 'https://github.com/blockstack/blockstack-ios-client'
  s.license     = { :type => "MIT" }
  s.authors     = { 'itsProf' => 'jorge@profapps.co' }
  s.requires_arc = true
  s.ios.deployment_target = '9.3'
  s.source   = { :git => 'https://github.com/blockstack/blockstack-ios-client.git', :tag => s.version }
  s.source_files = 'Blockstack/'
end
