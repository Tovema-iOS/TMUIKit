
# TMUIKit

常用 UI 封装

## Install

```ruby
source 'https://github.com/Tovema-iOS/Specs.git'

pod "TMUIKit", '~> 1.0'
```

## Usage

引用头文件

``` Objc
#import <TMUIKit/TMUIKit.h>
```

### TMToast

TMToast 用于显示消息

``` Objc
// 常用方式
TMToast.toast().setMessage(@"Hello wrold.").showTo(self.view);

// 更多定制
TMToast.toast() // 创建 toast
.clear() // 可选，清除正在显示或待显示的消息
.setMessage(@"Hello wrold.") // 设置消息
.setShowTime(1) // 可选，设置显示时间，默认3s
.setPosition(TMToastPositionCenterVertical) // 可选，设置消息显示位置，默认 TMToastPositionBottom
.setPositionYOffset(80)  // 可选，只是消息位置 Y 轴偏移量
.setActivityIndicatorStyle(TMToastIndicatorWhite) // 可选，设置等待动画样式，默认 TMToastIndicatorNone
.setModal(YES) // 可选，显示消息时是否禁止用户操作
.showTo(self.view); // 将 toast 加入消息队列，等待显示
```

关闭消息

``` Objc
// 关闭所有消息
[TMToast clear];
// 创建新消息时，清除旧消息
TMToast.toast().clear()...;
// 关闭指定消息
TMToast *toast = TMToast.toast()...;
[toast remove];
```

## Author

CodingPub, lxb_0605@qq.com

## License

TMUIKit is available under the MIT license. See the LICENSE file for more info.
