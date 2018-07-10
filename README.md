# Marvel Comics

[![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg?style=flat)](http://www.apple.com/ios/) [![Swift Version](https://img.shields.io/badge/Swift-4.1-orange.svg)]() 


This app allows viewing a list of Marvel Characters.


## Getting Started 

### Requirements
The current version requires:

- Xcode 9 or later.

- Swift 4.1 or later.

- iOS 9.3 or later.

### Installing

Add your public and private keys to `apikeys.plist` and just CMD + R to run the project. There is no thirdy library.


## Coding style

We are using the **MVVM - Model View View Model** pattern, where each View on the screen will be backed by a View Model that represents the data for the view.

#### View Controllers:
It is used only to display data.
Each view controller need to inherit from MCViewController class and override some properties:

```swift
// The storyboard name that the ViewController is embedded
override class var storyboardName: String {
  return {storyboard_name}
}

// The ViewController's ViewModel
fileprivate var viewModel: {view_model}? {
  return baseViewModel as? {view_model}
}
```

For exemple, for the MCCharacteresViewController, we have the follow implementation:

```swift
// MARK: Properties
override class var storyboardName: String {
  return MCIdentifiers.Storyboard.Main.name
}

private var viewModel: MCCharacteresViewModel? {
  return baseViewModel as? MCCharacteresViewModel
}
```

> IMPORTANT NOTE: The **Storyboard ID** should be the same name of the View Controller.

#### View Models
It is used to provide data to the view and should be able to accomodate the complete view.
It should not contain networking code or data access code, directity.

##### Binding:
Refers to the flow of information between the views and the view models.
We are dispatch events using blocks:

```swift
// Inside ViewModel
var onInformationChanged: (() -> Void)?
var onInformationFailed: ((Error?) -> Void)?

// Inside ViewController
viewModel.onInformationChanged = {
  ...
}
viewModel.onInformationFailed = { error in
  ...
}
```


## Test Coverage
Coverage Status: 55.02%


## Authors

* **Enrique Melgarejo**

## License

// This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

