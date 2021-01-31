# ImageCropper

![Swift](https://img.shields.io/badge/Swift-4.0-orange.svg)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](http://mit-license.org)
[![Platform](http://img.shields.io/badge/platform-ios-lightgrey.svg?style=flat)](https://developer.apple.com/resources/)


## Info
Basis on [MVP + Clean Architecture] (https://github.com/FortechRomania/ios-mvp-clean-architecture/)

Created with  [Generatus] (https://github.com/Ryasnoy/Generatus)

## Description
Module for implementing the process of cropping images

In the process of creating a variety of projects, developers often face the need to crop images (whether the user's avatar on the social network, background images, and so on).

Of course, iOS provides its own tools for image processing using the `Photos` application, but its use is not always convenient, justified, or even possible.

This library provides the ability to cut out sections of the original image in specified proportions by user's gesture interactions.


## Interface

### ImageCropperCompletion
`public typealias ImageCropperCompletion = (UIImage?) -> Void` - closure which is performed upon completion of the image cropping

### ImageCropperConfiguration
`ImageCropperFigureType` - figure types for cropping:
- `circle` - circle

- `square` - square (rectangle with aspect ratio 1 to 1)

- `rect2x1` - square (rectangle with aspect ratio* 2 to 1)

- `rect1x2` - square (rectangle with aspect ratio* 1 to 2)

- `rect4x3` - square (rectangle with aspect ratio* 4 to 3)

- `rect3x4` - square (rectangle with aspect ratio* 3 to 4)

- `rect16x9` - square (rectangle with aspect ratio* 16 to 9)

- `rect9x16` - square (rectangle with aspect ratio* 9 to 16)

- `customRect` - square (rectangle with custom aspect ratio)

*(first number is width, second - height) 

#### Сustom parameters
`customRatio` - size for creating  figure with custom aspect ratio. Value of this property will be used only if `figure = .customRect`. Default value - `CGSize(width: 1, height: 1)`

`maskFillColor` - fill color around cropped figure ("hole")

`borderColor` - color of cropped figure's ("hole") border

`showGrid` - specifies whether to display the grid

`gridColor` - color of grid's lines

`doneTitle` - title text of button for finishing cropping process (default: `Done`)

`cancelTitle` - itle text of button for canceling cropping process (default: `Cancel`)

## Updates

### v.0.1.4

**Added:**

- variable corner radius for cutted figure
    
**Fixed:**

- pinch gesture issue (thanks [davidpaul0880](https://github.com/davidpaul0880) for help)


### v.0.1.5
**Added:**

- Swift 5 support

## Usage Example

### Module Initialization
Set configuration:
```
var config = ImageCropperConfiguration(with: img, and: figure)
config.maskFillColor = UIColor(displayP3Red: 0.7, green: 0.5, blue: 0.2, alpha: 0.75)
config.borderColor = UIColor.black

config.showGrid = true
config.gridColor = UIColor.white
config.doneTitle = "CROP"
config.cancelTitle = "Back"
```

Initialize view controller:
```
let cropper = ImageCropperViewController.initialize(with: config) { croppedImage in
  /*
    Code to perform after finishing cropping process
  */
}
```
or
```
let cropper = ImageCropperViewController.initialize(with: config, completionHandler: { _croppedImage in
  /*
  Code to perform after finishing cropping process
  */
}) {
  /*
  Code to perform after dismissing controller
  */
}
```

Display with Navigation Controller:
```
navigationController.pushViewController(cropper, animated: true)
```

Present Modally:
```
viewController.present(cropper, animated: true, completion: nil)
```

### User interaction
`UIPanGestureRecognizer` - gesture for draging image below mask and grid

`UIPinchGestureRecognizer` - gesture for scaling image

`UITapGestureRecognizer` - double tap for centering and transforming image to the initial frame

### Suported Screen Orientation
iPhone Portrait

![](https://github.com/nkopilovskii/ImageCropper/blob/master/Example/ImageCropper/iPhone_Portrait.png)

iPhone Landscape

![](https://github.com/nkopilovskii/ImageCropper/blob/master/Example/ImageCropper/iPhone_Landscape.png)

iPad Portrait

![](https://github.com/nkopilovskii/ImageCropper/blob/master/Example/ImageCropper/iPad_Portrait.png)

iPad Landscape

![](https://github.com/nkopilovskii/ImageCropper/blob/master/Example/ImageCropper/iPhone_Landscape.png)

## Requirements
- iOS 11.0+
- Xcode 9.0

## Installation

ImageCropper is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```
pod 'ImageCropper'
```

## Author

Nick Kopilovskii, nkopilovskii@gmail.com

## License

ImageCropper is available under the MIT license. See the LICENSE file for more info.
