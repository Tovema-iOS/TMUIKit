//
//  TMToastView.m
//  TMUIKit
//
//  Created by LinXiaoBin on 2018/8/31.
//

#import "TMToastView.h"
#import <Masonry/Masonry.h>
#import <TMCategories/TMCategories.h>
#import <TMUtility/TMUtility.h>
#import "TMToast.h"

#define kLabelSpan          10.f

@interface TMToastView()

@property (nonatomic, weak) TMToast *toast;
@property (nonatomic, assign) NSTimeInterval showTime;

@end

@implementation TMToastView

+ (instancetype)viewForToast:(TMToast *)toast removeCompletion:(TMToastViewDidRemove)removeCompletion {
    return [[TMToastView alloc] initWithToast:toast removeCompletion:removeCompletion];
}

- (instancetype)initWithToast:(TMToast *)toast removeCompletion:(TMToastViewDidRemove)removeCompletion
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self) {
        self.toast = toast;
        self.removeCompletion = removeCompletion;
        
        self.userInteractionEnabled = NO;
        self.backgroundColor = toast.isModal ? RGBA(0, 0, 0, 0.2) : [UIColor clearColor];
        
        UIView *background = [UIView new].tm_backgroundColor(RGBA(0, 0, 0, 0.75)).tm_cornerRadius(8).tm_superView(self);
        
        UILabel *label = UILabel.tm_label.tm_text(toast.message).tm_textColor([UIColor whiteColor]).tm_lineBreakMode(NSLineBreakByWordWrapping).tm_numberOfLines(0).tm_textAlignment(toast.textAlignment)
                .tm_preferredMaxLayoutWidth(300).tm_superView(self);
        
        UIActivityIndicatorView *indicator = nil;
        if (toast.indicatorStyle != TMToastIndicatorNone) {
            indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)toast.indicatorStyle];
            [self addSubview:indicator];
            [indicator startAnimating];
        }
        
        CGSize lbSize = [label sizeThatFits:CGSizeMake(SCREEN_WIDTH-80, CGFLOAT_MAX)];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(lbSize);
            make.right.equalTo(background.mas_right).offset(-kLabelSpan);
            make.centerY.equalTo(background);
        }];
        
        [background mas_makeConstraints:^(MASConstraintMaker *make) {
            
            switch (toast.position) {
                case TMToastPositionTop:
                    make.top.equalTo(self).offset(toast.positionYOffset);
                    break;
                case TMToastPositionBottom:
                    make.bottom.equalTo(self).offset(-toast.positionYOffset);
                    break;
                case TMToastPositionCenterVertical:
                    make.centerY.equalTo(self).offset(-toast.positionYOffset);
                    break;
                default:
                    break;
            }
            
            make.centerX.equalTo(self);
            make.size.height.greaterThanOrEqualTo(label).offset(20);
            make.right.equalTo(label.mas_right).offset(kLabelSpan);
            
            if (indicator) {
                make.left.greaterThanOrEqualTo(indicator.mas_left).offset(-kLabelSpan);
                make.size.height.greaterThanOrEqualTo(indicator).offset(20);
            } else {
                make.left.greaterThanOrEqualTo(label.mas_left).offset(-kLabelSpan);
            }
        }];
        
        [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(label.mas_left).offset(-10);
            make.size.mas_equalTo(CGSizeMake(indicator.width, indicator.height));
            make.centerY.equalTo(label);
        }];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    self.frame = newSuperview.bounds;
    [self setNeedsLayout];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        if (self.toast.showTime > 0) {
            
            [self performSelector:@selector(removeToast) withObject:nil afterDelay:self.toast.showTime inModes:@[NSRunLoopCommonModes]];
//            [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:self.toast.showTime];
        }
    }];
    
    if (self.toast.isModal) {
        self.superview.userInteractionEnabled = NO;
    }
}

- (void)removeToast {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(removeToast) object:nil];
    
    [self.layer removeAllAnimations];
    
    if (self.toast.isModal) {
        self.superview.userInteractionEnabled = YES;
    }
    
    if (self.window) {
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0.2;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            
            TMToastViewDidRemove callback = self.removeCompletion;
            if (callback) {
                callback(self.toast);
            }
        }];
    } else {
        TMToastViewDidRemove callback = self.removeCompletion;
        if (callback) {
            callback(self.toast);
        }
    }
}

@end
