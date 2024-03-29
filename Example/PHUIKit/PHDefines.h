//
//  Header.h
//  PandaHome
//
//  Created by leihui on 13-7-3.
//  Copyright (c) 2013年 ND WebSoft Inc. All rights reserved.
//

#ifndef PandaHome_Header_h
#define PandaHome_Header_h

#define SYSTEM_VERSION [[UIDevice currentDevice].systemVersion floatValue]
#define HOME_VERSION_STRING [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]

#define STATUSBAR_HEIGHT 20
#define NAVIGATIONBAR_HEIGHT 44
#define SUB_TABBAR_HEIGHT 44
#define kTopTabHeight 36

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define kApplication_Heigh (SCREEN_HEIGHT - 20)
#define kAppView_Height (kApplication_Heigh - 44)

//判断是否是iPhone4设备
#define iPhone4 ([UIScreen mainScreen].bounds.size.height == 480)

//判断是否是iPhone5设备
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#if 1
#define iPhone6OrPlus (([TMDeviceInfo deviceModel] == GBDeviceModeliPhone6) || ([TMDeviceInfo deviceModel] == GBDeviceModeliPhone6Plus) || ([TMDeviceInfo deviceModel] == GBDeviceModeliPhone6s) || ([TMDeviceInfo deviceModel] == GBDeviceModeliPhone6sPlus))
#define iPhone7OrPlus (([TMDeviceInfo deviceModel] == GBDeviceModeliPhone7) || ([TMDeviceInfo deviceModel] == GBDeviceModeliPhone7Plus))
#else
#warning 测试
#define iPhone6OrPlus 1
#endif

//宽度高度缩放因子
#define iPhoneWidthScaleFactor ([UIScreen mainScreen].bounds.size.width / 320.f)

//插件宽度缩放因子
#define kWidgetWidthScaleFactor ([TMDeviceInfo isiPad] ? ((([[UIScreen mainScreen] currentMode].size.width - 176.f * [UIScreen mainScreen].scale) / [UIScreen mainScreen].scale) / 320) : (([[UIScreen mainScreen] currentMode].size.width / [UIScreen mainScreen].scale) / 320))

//iPhone6 Plus横屏
#define iPhone6PlusOrientationLandscape (([TMDeviceInfo deviceModel] == GBDeviceModeliPhone6Plus || [TMDeviceInfo deviceModel] == GBDeviceModeliPhone6sPlus || [TMDeviceInfo deviceModel] == GBDeviceModeliPhone7Plus) && ([[UIScreen mainScreen] bounds].size.width >= 736.f))
//通知中心插件在iPhone 6 Plus横屏下居中偏移量
#define kWidgetXOffsetCenter (iPhone6PlusOrientationLandscape ? ((666.f - 320 * kWidgetWidthScaleFactor) / 2) : 0)
//通知中心插件宽度
#define kWidgetContentWidth ([TMDeviceInfo isiPad] ? 592.f : (iPhone6PlusOrientationLandscape ? 666.f : [[UIScreen mainScreen] bounds].size.width))

//默认背景
#define kNewWebShopBGColor [UIColor whiteColor]
#define kViewBackgroundColor [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.7f]
//随机颜色
#define kRandomColor [UIColor colorWithRed:(CGFloat)(arc4random() % 256) / 255 green:(CGFloat)(arc4random() % 256) / 255 blue:(CGFloat)(arc4random() % 256) / 255 alpha:1.0]

//UIColor
#define RGB(r, g, b) [UIColor colorWithRed:(float)(r) / 255.f green:(float)(g) / 255.f blue:(float)(b) / 255.f alpha:1.0f]
#define RGBA(r, g, b, a) [UIColor colorWithRed:(float)(r) / 255.f green:(float)(g) / 255.f blue:(float)(b) / 255.f alpha:a]

#define WINDOW [[[UIApplication sharedApplication] delegate] window]

#define _(s) NSLocalizedString((s), @"")

#define getResource(name) [[ResourcesManager sharedInstance] imageWithFileName:name]

#define SB_RELEASE_SAFELY(__POINTER) \
    {                                \
        [__POINTER release];         \
        __POINTER = nil;             \
    }
#define SB_INVALIDATE_TIMER(__TIMER) \
    {                                \
        [__TIMER invalidate];        \
        __TIMER = nil;               \
    }

#define APPID [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Application ID"]

//格式化容量大小
#define Localizable_LF_Size_Bytes @"%lld Bytes"
#define Localizable_LF_Size_K @"%lld KB"
#define Localizable_LF_Size_M @"%lld.%lld M"
#define Localizable_LF_Size_G @"%lld.%d G"
#define Localizable_LF_All_Size_M @"%lld.%lld M"
#define Localizable_LF_All_Size_G @"%lld.%lld G"

#define TICK NSDate *startTime = [NSDate date]
#define TOCK NSLog(@"Time:>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>%f", -[startTime timeIntervalSinceNow])

//日历
#define kalViewWidth (280 * iPhoneWidthScaleFactor)
#define kalViewHeight (260 * iPhoneWidthScaleFactor)

// 侧滑菜单标记，用来测试侧滑菜单
#define kSideMenuFlag 1

#endif
