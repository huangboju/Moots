# HHPullToRefreshWave

[![travis CI](https://img.shields.io/travis/red3/HHPullToRefreshWave/master.svg)](http://cocoapods.org/pods/HHPullToRefreshWave)
[![Version](https://img.shields.io/cocoapods/v/HHPullToRefreshWave.svg?style=flat)](http://cocoapods.org/pods/HHPullToRefreshWave)
[![License](https://img.shields.io/cocoapods/l/HHPullToRefreshWave.svg?style=flat)](http://cocoapods.org/pods/HHPullToRefreshWave)
[![Platform](https://img.shields.io/cocoapods/p/HHPullToRefreshWave.svg?style=flat)](http://cocoapods.org/pods/HHPullToRefreshWave)

Wave animation pull to refresh for iOS, inspired by Mayijubao app 

![](https://raw.githubusercontent.com/red3/HHPullToRefreshWave/master/HHPullToRefreshWavePreview1.gif)

For more details visit this [blog](http://blog.coderhr.com/2015/12/10/waveview-with-cadisplaylink/).

## Requirements

* Xcode7 or higher
* iOS 7.0 or higher (may work on previous versions, just did not test it)
* ARC
* Objective-C

## Demo
Open and run the Demo project in Xcode to see HHPullToRefreshWave in action.

## Installation

### CocoaPods

```ruby
pod "HHAttachmentSheetView"
``` 

### Manual

Add HHPullToRefreshWave folder into your project.

## Example usage

``` objective-c

 [self.tableView hh_addRefreshViewWithActionHandler:^{
        NSLog(@"action");
    }];
 [self.tableView hh_setRefreshViewTopWaveFillColor:[UIColor lightGrayColor]];
 [self.tableView hh_setRefreshViewBottomWaveFillColor:[UIColor whiteColor]];
    
```
Do not forget to remove pull to refresh on view controller dealloc. It is a temporary solution

``` objective-c
 [self.tableView hh_removeRefreshView];
```
### Description

Add pull to refresh with a block handler:

``` objective-c
[self.tableView hh_addRefreshViewWithActionHandler:^{
        NSLog(@"action");
    }];
```
Remove pull to refresh:

``` objective-c
[self.tableView hh_removeRefreshView];
```
Change top wave fill color:

``` objective-c
 [self.tableView hh_setRefreshViewTopWaveFillColor:[UIColor lightGrayColor]];
```

Change bottom wave fill color:

``` objective-c
 [self.tableView hh_setRefreshViewBottomWaveFillColor:[UIColor whiteColor]];
```

## Contribution 

Please feel free to submit pull request, also submit a issue if you have any questions.

## Contact 

- https://github.com/red3

## License
The MIT License (MIT)

Copyright (c) 2015 Herui

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


 

