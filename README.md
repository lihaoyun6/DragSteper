<p align="center">
<img src="./img/preview.png#gh-light-mode-only" width="273" />
<img src="./img/preview_dark.png#gh-dark-mode-only" width="273" />
<h1 align="center">DragSteper</h1>
<h3 align="center">A draggable stepper controller for macOS<br><a href="./README_zh.md">[中文版本]</a></h3>
</p>

## Introduction
This package lets you to use draggable steppers like on macOS 15 to control digital inputs on older macOS  

## Requirements
macOS 11.0+

## Install
Add `https://github.com/lihaoyun6/DragSteper` to your project using [Swift Package Manager](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app) in Xcode  

## Usage

First, import `DragSteper` into your code:  

```swift
import DragSteper
```

Then you can:

```swift
import SwiftUI
import DragSteper

struct ContentView: View {
    @State var number: Int = 0
    @State var isPresented: Bool = false
    
    var body: some View {
        HStack {
            TextField("Test", value: $number, formatter: NumberFormatter())
                .popover(isPresented: $isPresented) {
                    DragSteper(value: $number)
                }
            Button("Edit") {
                isPresented = true
            }
        }.padding()
    }
}
```
When you click this button, a draggable stepper will pop up for fine-tuning the bound value.   

You can also control the range using the `minValue` and `maxValue` parameters, or enable haptic feedback by adding `haptic: true`:

```swift
...
DragSteper(value: $number, minValue: 1, maxValue: 100, haptic: true)
...
```  
