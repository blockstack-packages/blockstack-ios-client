platform :ios, '10.0'
use_frameworks!

def swift3_overrides
    pod 'Alamofire', git: 'https://github.com/Alamofire/Alamofire.git', branch: 'swift3'
end

target 'Blockstack' do
	swift3_overrides
	
	pod 'Alamofire'
end
