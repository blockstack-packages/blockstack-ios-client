# blockstack-ios-client
iOS client for blockstack-server.

####Installation

Installation is done through [CocoaPods](http://cocoapods.org/), a Swift and Objective-C dependency manager. Visit their site for more information about [CocoaPods](http://cocoapods.org/) configuration and installation.

Add `BlockstackClient` to your `Podfile`:

```ruby
platform :ios, '9.3'
use_frameworks!

target 'MyAppTarget' do
	pod 'BlockstackClient', :git => 'https://github.com/blockstack/blockstack-ios-client.git'
end
```

####Initialization

To use the client, the first step is to import the framework where you need it.

```swift
import BlockStackClient
```
Initialize the framework on your app delegate's `didFinishLaunchingWithOptions` method.

```swift
BlockstackClient.initialize(appId: "YOUR_APP_ID", appSecret: "YOUR_APP_SECRET")
```

The `appId` and `appSecret` values are obtained by signing up for a [Onename API](https://api.onename.com) account.

####Usage

To use the client, call any of the provided methods. The documentation has a complete list of methods, parameters and return values. The following example shows how to look up a user based on his or her username:

```swift
BlockstackClient.lookup(users: ["itsProf"]) { (response, error) in
  if let error = error {
    NSLog("Error: \(error.localizedDescription)", error)
    return
  }
            
  if let response = response?.rawString() {
    print(response)
  }
}
```

Client responses are parsed to JSON using [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON).
