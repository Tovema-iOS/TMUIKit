//
//  TMWebViewController.h
//  TMUIKit-TMUIKit
//
//  Created by LinXiaoBin on 2018/9/10.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

/**
 简单 WebViewController 封装类
 */
@interface TMWebViewController : UIViewController <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong, readonly) WKWebView *webView;
@property (nonatomic, strong, readonly) NSURL *requestURL;

@property (nonatomic, assign) BOOL showWebTitle;  // 导航栏是否显示网页标题, default=NO
@property (nonatomic, assign) BOOL showToolbar;  // 是否显示底部 Toolbar, default=YES

- (instancetype)init;
- (instancetype)initWithURL:(NSURL *)url;
- (instancetype)initWithURLString:(NSString *)urlString;

- (void)requestWithURLString:(NSString *)urlString;
- (void)requestWithURL:(NSURL *)url;

@end
