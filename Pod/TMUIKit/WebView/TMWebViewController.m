//
//  TMWebViewController.m
//  TMUIKit-TMUIKit
//
//  Created by LinXiaoBin on 2018/9/10.
//

#import "TMWebViewController.h"
#import <Masonry/Masonry.h>
#import <TMCategories/TMCategories.h>
#import <TMUtility/TMUtility.h>
#import "TMWebViewDefaultDelegate.h"

#define RESOURCE_BUNDLE_PATH     [[NSBundle mainBundle] pathForResource:@"TMUIKit" ofType:@"bundle"]
#define IMAGE_IN_BUNDLE(imagePath, bundlePath) [UIImage imageWithContentsOfFile:[bundlePath stringByAppendingPathComponent:(imagePath)]]
#define IMAGE(imagePath) IMAGE_IN_BUNDLE((imagePath), RESOURCE_BUNDLE_PATH)

@interface TMWebViewController () {
    // Toolbar and used buttons
    UIToolbar *_toolbar;
    
    UIBarButtonItem *_reloadButton;
    UIBarButtonItem *_loadingButton;
    UIBarButtonItem *_forwardButton;
    UIBarButtonItem *_backButton;
    UIBarButtonItem *_flexibleSpace;
    
    UILabel *_lbPromote;
    
    TMReceptionist *_titleReceptionist;
    
    TMWebViewDefaultDelegate *_defaultDelegate;
}

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSURL *requestURL;

@end

@implementation TMWebViewController

- (instancetype)init {
    return [self initWithURL:nil];
}

- (instancetype)initWithURLString:(NSString *)urlString {
    NSURL *url = urlString ? [NSURL URLWithString:urlString] : nil;
    return [self initWithURL:url];
}

- (instancetype)initWithURL:(NSURL *)url {
    if (self = [super init]) {
        _requestURL = url;
        _showToolbar = YES;
        _showWebTitle = NO;
        _defaultDelegate = [TMWebViewDefaultDelegate new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createViews];
    [self requestWithURL:self.requestURL];
    
    [self updateTitleKVO];
    [self updateToolbar];
}

- (void)requestWithURLString:(NSString *)urlString {
    NSURL *url = urlString ? [NSURL URLWithString:urlString] : nil;
    [self requestWithURL:url];
}

- (void)requestWithURL:(NSURL *)url {
    if (!url) {
        return;
    }
    
    self.requestURL = url;
    NSURLRequest *reuest = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:reuest];
}

- (void)setShowWebTitle:(BOOL)showWebTitle {
    _showWebTitle = showWebTitle;
    
    [self updateTitleKVO];
}

- (void)updateTitleKVO {
    if (self.showWebTitle && self.webView) {
        typeof(self) __weak weakSelf = self;
        _titleReceptionist = [TMReceptionist receptionistForKeyPath:@"title" object:self.webView dispatchQueue:dispatch_get_main_queue() task:^(NSString *keyPath, id object, NSDictionary *change) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.title = change[NSKeyValueChangeNewKey];
        }];
    } else {
        _titleReceptionist = nil;
    }
}

- (void)setShowToolbar:(BOOL)showToolbar {
    _showToolbar = showToolbar;
    [self updateToolbar];
}

- (void)updateToolbar {
    if (!_toolbar) {
        return;
    }
    
    if (_showToolbar) {
        _toolbar.hidden = NO;
        
        [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 44, 0));
        }];
    } else {
        _toolbar.hidden = YES;
        
        [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    BOOL responds = [super respondsToSelector:aSelector];
    if (!responds) {
        responds = [_defaultDelegate respondsToSelector:aSelector];
    }
    return responds;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([_defaultDelegate respondsToSelector:aSelector]) {
        return _defaultDelegate;
    }
    return nil;
}

#pragma mark - private
- (void)createViews {
    WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectNull configuration:webConfig];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
    
    _lbPromote = UILabel.tm_label.tm_text(@"页面加载异常!").tm_font([UIFont systemFontOfSize:14]).tm_textColor([UIColor blackColor]).tm_superView(self.view);
    _lbPromote.hidden = YES;
    
    [self createToolBar];

    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 44, 0));
    }];
    
    [_lbPromote mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
}

- (void)createToolBar {
    _reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reload)];
    
    // Create loading button that is displayed if the web view is loading anything
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityView startAnimating];
    _loadingButton = [[UIBarButtonItem alloc] initWithCustomView:activityView];
    
    // Shows the next page, is disabled by default. Web view checks if it can go forward and disables the button if neccessary
    _forwardButton = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"PWWebViewControllerArrowRight.png") style:UIBarButtonItemStylePlain target:self action:@selector(goForward)];
    _forwardButton.enabled = NO;
    
    // Shows the last page, is disabled by default. Web view checks if it can go back and disables the button if neccessary
    _backButton = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"PWWebViewControllerArrowLeft.png") style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    _backButton.enabled = NO;
    
    _toolbar = [[UIToolbar alloc] init];
    [self.view addSubview:_toolbar];
    
    // Flexible space
    _flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    
    [self showNormalToolbar];
    
    [_toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.left.equalTo(self.view);
        make.top.equalTo(self.webView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
}

- (void)checkNavigationStatus
{
    // Check if we can go forward or back
    _backButton.enabled = self.webView.canGoBack;
    _forwardButton.enabled = self.webView.canGoForward;
}

- (void)reload
{
    [self.webView stopLoading];
    [self.webView reload];
}

- (void)goBack
{
    if (self.webView.canGoBack == YES) {
        // We can go back. So make the web view load the previous page.
        [self.webView goBack];
        
        // Check the status of the forward/back buttons
        [self checkNavigationStatus];
    }
}

- (void)goForward
{
    if (self.webView.canGoForward == YES) {
        // We can go forward. So make the web view load the next page.
        [self.webView goForward];
        
        // Check the status of the forward/back buttons
        [self checkNavigationStatus];
    }
}

- (void)showNormalToolbar {
    _toolbar.items = [NSArray arrayWithObjects: _flexibleSpace, _backButton, _flexibleSpace, _forwardButton, _flexibleSpace, _reloadButton, _flexibleSpace, nil];
    
}

- (void)showLoadingToolbar {
    _toolbar.items = [NSArray arrayWithObjects: _flexibleSpace, _backButton, _flexibleSpace, _forwardButton, _flexibleSpace, _loadingButton, _flexibleSpace, nil];
    
}

- (void)onFailLoadWebView {
    _lbPromote.hidden = NO;
    
    [self showNormalToolbar];
    [self checkNavigationStatus];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    _lbPromote.hidden = YES;
    
    [self showLoadingToolbar];
    [self checkNavigationStatus];
    
    [self performSelector:@selector(checkNavigationStatus) withObject:nil afterDelay:0.5];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [self showNormalToolbar];
    [self checkNavigationStatus];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [self onFailLoadWebView];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [self onFailLoadWebView];
}

@end
