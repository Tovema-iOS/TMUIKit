//
//  TMToast.m
//  TMUtility
//
//  Created by LinXiaoBin on 2018/8/30.
//

#import "TMToast.h"
#import "TMToastView.h"

static TMToast *tm_currentToast = nil;
static NSMutableArray<TMToast *> *tm_toastArray;
static dispatch_semaphore_t tm_toastLock;

@interface TMToast()
{
}

@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, assign) CGFloat positionYOffset;
@property (nonatomic, assign) TMToastPosition position;
@property (nonatomic, assign) BOOL modal;
@property (nonatomic, assign) TMToastIndicator indicatorStyle;
@property (nonatomic, assign) NSTimeInterval showTime;
@property (nonatomic, weak) UIView *container;

@property (nonatomic, strong) TMToastView *messageView;

@end

@implementation TMToast

+ (void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tm_toastArray = [NSMutableArray array];
        tm_toastLock = dispatch_semaphore_create(1);
    });
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _position = TMToastPositionBottom;
        _modal = NO;
        _showTime = 2;
        _positionYOffset = 60;
        _textAlignment = NSTextAlignmentCenter;
        _indicatorStyle = TMToastIndicatorNone;
    }
    return self;
}

+ (TMToast * (^)(void))toast
{
    return ^id() {
        return [TMToast new];
    };
}

- (TMToast * (^)(NSString *message))setMessage
{
    return ^id(NSString *message) {
        self.message = message;
        return self;
    };
}

- (TMToast * (^)(NSTextAlignment textAlignment))setTextAlignment
{
    return ^id(NSTextAlignment textAlignment) {
        self.textAlignment = textAlignment;
        return self;
    };
}

- (TMToast * (^)(TMToastPosition position))setPosition
{
    return ^id(TMToastPosition position) {
        self.position = position;
        return self;
    };
}

- (TMToast * (^)(CGFloat positionYOffset))setPositionYOffset
{
    return ^id(CGFloat positionYOffset) {
        self.positionYOffset = positionYOffset;
        return self;
    };
}

- (TMToast * (^)(NSTimeInterval showTime))setShowTime
{
    return ^id(NSTimeInterval showTime) {
        self.showTime = showTime;
        return self;
    };
}

- (TMToast * (^)(BOOL modal))setModal
{
    return ^id(BOOL modal) {
        self.modal = modal;
        return self;
    };
}

- (TMToast * (^)(TMToastIndicator style))setActivityIndicatorStyle
{
    return ^id(TMToastIndicator style) {
        self.indicatorStyle = style;
        return self;
    };
}

- (TMToast * (^)(UIView *container))showTo
{
    return ^id(UIView *container) {
        self.container = container;
        [TMToast addToast:self];
        [TMToast showToast];
        return self;
    };
}

- (void)remove
{
    [self.messageView removeToast];
    [TMToast removeToast:self];
}

- (TMToast * (^)(void))clear
{
    return ^id() {
        [TMToast clear];
        return self;
    };
}

+ (void)clear
{
    NSArray<TMToast *> *array = [TMToast clearToast];
    [array enumerateObjectsUsingBlock:^(TMToast *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [obj.messageView removeToast];
    }];
}

#pragma mark - private

+ (void)showToast
{
    TMToast *toast = nil;

    dispatch_semaphore_wait(tm_toastLock, DISPATCH_TIME_FOREVER);
    if (!tm_currentToast && tm_toastArray.count > 0) {
        tm_currentToast = tm_toastArray.firstObject;
        toast = tm_currentToast;
    }
    dispatch_semaphore_signal(tm_toastLock);

    if (!toast) {
        return;
    }

    toast.messageView = [TMToastView viewForToast:toast
                                 removeCompletion:^(TMToast *toast) {
                                     [TMToast removeToast:toast];

                                     dispatch_semaphore_wait(tm_toastLock, DISPATCH_TIME_FOREVER);
                                     if (tm_currentToast == toast) {
                                         tm_currentToast = nil;
                                     }
                                     dispatch_semaphore_signal(tm_toastLock);

                                     [TMToast showToast];
                                 }];

    if (!toast.container) {
        [toast remove];
        [self performSelectorOnMainThread:@selector(showToast) withObject:nil waitUntilDone:NO];
        return;
    }

    [toast.container addSubview:toast.messageView];
}

+ (void)addToast:(TMToast *)toast
{
    dispatch_semaphore_wait(tm_toastLock, DISPATCH_TIME_FOREVER);
    [tm_toastArray addObject:toast];
    dispatch_semaphore_signal(tm_toastLock);
}

+ (void)removeToast:(TMToast *)toast
{
    dispatch_semaphore_wait(tm_toastLock, DISPATCH_TIME_FOREVER);
    [tm_toastArray removeObject:toast];
    if (tm_currentToast == toast) {
        tm_currentToast = nil;
    }
    dispatch_semaphore_signal(tm_toastLock);
}

+ (NSArray<TMToast *> *)clearToast
{
    dispatch_semaphore_wait(tm_toastLock, DISPATCH_TIME_FOREVER);
    NSArray *array = tm_toastArray.copy;
    [tm_toastArray removeAllObjects];
    tm_currentToast = nil;
    dispatch_semaphore_signal(tm_toastLock);
    return array;
}

@end
