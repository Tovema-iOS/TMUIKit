//
//  TMToastView.h
//  TMUIKit
//
//  Created by LinXiaoBin on 2018/8/31.
//

#import <UIKit/UIKit.h>

@class TMToast;

typedef void (^TMToastViewDidRemove)(TMToast *toast);

@interface TMToastView : UIView

@property (nonatomic, copy) TMToastViewDidRemove removeCompletion;

+ (instancetype)viewForToast:(TMToast *)toast removeCompletion:(TMToastViewDidRemove)removeCompletion;

- (void)removeToast;

@end
