# SPFoundationCategory

[![CI Status](https://img.shields.io/travis/1210233/SPFoundationCategory.svg?style=flat)](https://travis-ci.org/1210233/SPFoundationCategory)
[![Version](https://img.shields.io/cocoapods/v/SPFoundationCategory.svg?style=flat)](https://cocoapods.org/pods/SPFoundationCategory)
[![License](https://img.shields.io/cocoapods/l/SPFoundationCategory.svg?style=flat)](https://cocoapods.org/pods/SPFoundationCategory)
[![Platform](https://img.shields.io/cocoapods/p/SPFoundationCategory.svg?style=flat)](https://cocoapods.org/pods/SPFoundationCategory)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

SPFoundationCategory is available through [SPM](Swift-Package-Manager). 

Add SPFoundationCategory by your project dependency, In XCode:

  Step 1, open your project and click menus by `File -> Swift Packages -> Add Package Dependency...`.
  
  Step 2, in the "Enter package repository URL" field, fill `https://github.com/1210233/SPFoundationCategory.git` into it.
  
  Step 3, select a version rule which you want and click `next`, then click `Finish`.

Add SPFoundationCategory by your `package dependency`, In File `Package.swift`:

  let package = Package(name: "SomePackage",
  
                      platforms: [],
                      
                      products: [.library(name: "SomePackage",
                      
                                          targets: ["SomePackage"])],
                                          
                      dependencies: [
                      
                          // Dependencies declare other packages that this package depends on.
                          
                        .package(url: "https://github.com/1210233/SPFoundationCategory.git", from: Version(1, 0, 0)),
                        
                      ],
                      
                      targets: [.target(name: "SomePackage",
                      
                                        dependencies: ["SPFoundationCategory"],
                                        
                                        path: "Sources")
                                        
                                ]
                                
                        )
                        
                        
## Author

1210233, 1210233@163.com

## License

SPFoundationCategory is available under the MIT license. See the LICENSE file for more info.

