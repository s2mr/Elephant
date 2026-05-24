<h1 align="center">Elephant</h1>

<p align="center"><strong>This is SVG animation presentation kit for iOS.</strong></p>

<p align="center">
<a href="https://developer.apple.com/swift"><img alt="Swift" src="https://img.shields.io/badge/language-Swift-orange.svg"/></a>
<a href="https://github.com/s2mr/Elephant/releases/latest"><img alt="Release" src="https://img.shields.io/github/release/s2mr/Elephant.svg"/></a>
<a href="https://cocoapods.org/pods/Elephant"><img alt="CocoaPods" src="https://img.shields.io/cocoapods/v/Elephant.svg"/></a>
<a href="https://app.fossa.io/projects/git%2Bgithub.com%2Fkzumu%2FElephant?ref=badge_shield" alt="FOSSA Status"><img src="https://app.fossa.io/api/projects/git%2Bgithub.com%2Fkzumu%2FElephant.svg?type=shield"/></a>
</br>
<a href="https://developer.apple.com/"><img alt="Platform" src="https://img.shields.io/badge/platform-iOS-green.svg"/></a>
<a href="https://github.com/s2mr/Elephant/blob/master/LICENSE"><img alt="Lincense" src="https://img.shields.io/badge/License-Apache%202.0-black.svg"/></a>
</p>

## Example
You can run the example app from `Examples/iOS/Example-iOS.xcodeproj`.

<img src="https://github.com/s2mr/Elephant/raw/resources/Resources/demo.gif" width="300" align="center"/>

## Usage
You can display the svg image with animation.

**We are supportted two animation formats😎**

The format is below.
- Animation in SVG
- Animation in CSS

Usage is difference by the format.

### SVGView initialization

This is initialization SVGView for format 1 (Animation in SVG) usage.
```swift
SVGView(named: "svg-filename", animationOwner: .svg)
```

This is initialization SVGView for format 2 (Animation in CSS) usage.
```swift
SVGView(named: "svg-filename", animationOwner: .css, style: .cssFile(name: "css-filename"))
```

### Show in your ViewController

And, you initialized view, you have to do is only add view to parent view, and start animation like below.
```swift
class ViewController: UIViewController {
    let svgView = SVGView(named: "image", animationOwner: .svg)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(svgView)
        svgView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            svgView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            svgView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            svgView.widthAnchor.constraint(equalToConstant: 400),
            svgView.heightAnchor.constraint(equalToConstant: 400),
        ])

        svgView.startAnimation()

        // svgView.stopAnimation()    // Stop animation.

        // svgView.isAnimate { [weak self] (value, error) in
        //     if let error = error {
        //         print(error)
        //     }
        //     guard let value = value else { return } // value means whether animation is moving.
        // }
    }
}

```

### Show in SwiftUI

SwiftUI support is available on iOS 13.0 and later.

```swift
import SwiftUI
import Elephant

struct ContentView: View {
    var body: some View {
        AnimatedSVGView(named: "image", animationOwner: .svg)
            .frame(width: 240, height: 240)
    }
}
```

## Requirements
- Xcode 26.4
- Swift 6.0 package tools
- iOS 12.0+

## Installation

### [Swift package manager](https://github.com/apple/swift-package-manager)

Add the following to the dependencies of your Package.swift:

``` swift
dependencies: [
    .package(url: "https://github.com/s2mr/Elephant.git", from: "Elephant version"),
]
```

### [CocoaPods](https://cocoapods.org)
Add this to `Podfile`

```ruby
pod 'Elephant'
```

```bash
$ pod install
```

## Author

[Kazumasa Shimomura](https://www.kazuringo.xyz)

## License

Elephant is available under the Apache v2. See the LICENSE file for more info.


[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%s2mr%2FElephant.svg?type=large)](https://app.fossa.io/projects/git%2Bgithub.com%2Fs2mr%2FElephant?ref=badge_large)

## Star History

<a href="https://www.star-history.com/#s2mr/Elephant&Date">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=s2mr/Elephant&type=Date&theme=dark" />
    <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=s2mr/Elephant&type=Date" />
    <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=s2mr/Elephant&type=Date" />
  </picture>
</a>
