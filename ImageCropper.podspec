#
# Be sure to run `pod lib lint ImageCropper.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ImageCropper'
  s.version          = '0.1.5'
  s.summary          = 'Module for implementing the process of cropping images'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Module for implementing the process of cropping images

In the process of creating a variety of projects, developers often face the need to crop images (whether the user's avatar on the social network, background images, and so on).

Of course, iOS provides its own tools for image processing using the "Photos" application, but its use is not always convenient, justified, or even possible.

This library provides the ability to cut out sections of the original image in specified proportions by user's gesture interactions.

This solution presents itself a module developed on the basis of MVP + Clean Architecture (https://github.com/FortechRomania/ios-mvp-clean-architecture/) by code generator Generatus (https://github.com/Ryasnoy/Generatus)
                       DESC

  s.homepage         = 'https://github.com/nkopilovskii/ImageCropper'
  s.screenshots      = 'https://github.com/nkopilovskii/ImageCropper/ImageCropper.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Nick Kopilovskii' => 'nkopilovskii@gmail.com' }
  s.source           = { :git => 'https://github.com/nkopilovskii/ImageCropper.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/MKopilovskii'
  s.ios.deployment_target = '10.0'

  s.swift_version  = '3.0'
  s.source_files = 'ImageCropper/Classes/**/*.{xib,swift}'
  
  # s.resource_bundles = {
  #   'ImageCropper' => ['ImageCropper/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
#'MapKit'
# s.dependency 'AFNetworking', '~> 2.3'
end
