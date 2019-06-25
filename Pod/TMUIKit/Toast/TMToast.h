//
//  TMToast.h
//  TMUtility
//
//  Created by LinXiaoBin on 2018/8/30.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TMToastPosition) {
    TMToastPositionTop,
    TMToastPositionCenterVertical,
    TMToastPositionBottom,
};

typedef NS_ENUM(NSUInteger, TMToastIndicator) {
    TMToastIndicatorWhiteLarge = UIActivityIndicatorViewStyleWhiteLarge,
    TMToastIndicatorWhite = UIActivityIndicatorViewStyleWhite,
    TMToastIndicatorNone,
};

@class TMToastView;
@interface TMToast : NSObject

@property (nonatomic, copy, readonly) NSString *message;
@property (nonatomic, assign, readonly) NSTextAlignment textAlignment;
@property (nonatomic, assign, readonly) CGFloat positionYOffset;
@property (nonatomic, assign, readonly) TMToastPosition position;
@property (nonatomic, assign, readonly, getter=isModal) BOOL modal;
@property (nonatomic, assign, readonly) TMToastIndicator indicatorStyle;
@property (nonatomic, assign, readonly) NSTimeInterval showTime;

@property (nonatomic, strong, readonly) TMToastView *messageView;

+ (TMToast * (^)(void))toast;

- (TMToast * (^)(UIView *container))showTo;
- (void)remove;

- (TMToast * (^)(NSString *message))setMessage; // 设置消息
- (TMToast * (^)(NSTextAlignment textAlignment))setTextAlignment; // 设置文字对齐方式, default=NSTextAlignmentCenter

- (TMToast * (^)(TMToastPosition position))setPosition; // 设置显示位置

/**
 设置位置偏移量，默认 60
 TMToastPositionTop 向下偏移
 TMToastPositionCenterVertical/TMToastPositionBottom 向上偏移
 */
- (TMToast * (^)(CGFloat positionYOffset))setPositionYOffset;

- (TMToast * (^)(NSTimeInterval showTime))setShowTime; // 设置显示时长，默认3s，=0 时不自动移除

- (TMToast * (^)(BOOL modal))setModal; // 是否模态弹框
- (TMToast * (^)(TMToastIndicator style))setActivityIndicatorStyle; // 等待动画样式

- (TMToast * (^)(void))clear;
+ (void)clear;

@end
