<p align="center">
<img src="./img/preview.png#gh-light-mode-only" width="273" />
<img src="./img/preview_dark.png#gh-dark-mode-only" width="273" />
<h1 align="center">DragSteper</h1>
<h3 align="center">适用于 macOS 的拖拽式数字步进器控件<br><a href="./README.md">[English Version]</a></h3>
</p>

## 简介
利用此扩展包, 你可以在低版本系统中使用类似 macOS 15 上的拖拽式步进器来控制数字输入  

## 系统要求
macOS 11.0+

## 安装
使用 Xcode 内置的 [Swift Package Manager](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app) 将 `https://github.com/lihaoyun6/DragSteper` 添加到你的项目中  

## Usage

添加完成后首先引入 `DragSteper`:  

```swift
import DragSteper
```

然后可以这样为你的 `TextField` 或其他控件添加一个 `popover` 以及用于触发的按钮:

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
当用户点击此按钮时, 将会弹出用于微调数字值的拖拽式步进器.  

你还可以通过添加 `minValue` 或 `maxValue` 参数来控制调节范围, 或使用 `haptic: true` 参数来启用触感反馈震动:  

```swift
...
DragSteper(value: $number, minValue: 1, maxValue: 100, haptic: true)
...
```  
