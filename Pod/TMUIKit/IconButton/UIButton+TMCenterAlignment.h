//
//  UIButton+TMCenterAlignment.h
//  TMUIKit-TMUIKit
//
//  Created by LinXiaoBin on 2018/9/10.
//

#import <UIKit/UIKit.h>

/**
 UIButton image & title 居中对齐扩展
 */
@interface UIButton(TMCenterAlignment)

/**
 *  水平居中按钮 image 和 title
 *
 *  @param spacing - image 和 title 的水平间距, 单位point
 */
- (void)tm_horizontalCenterImageAndTitleWithSpacing:(float)spacing;

/**
 *  水平居中按钮 title 和 image
 *
 *  @param spacing - image 和 title 的水平间距, 单位point
 */
- (void)tm_horizontalCenterTitleAndImageWithSpacing:(float)spacing;

/**
 *  垂直居中按钮 image 和 title
 *
 *  @param spacing - image 和 title 的垂直间距, 单位point
 */
- (void)tm_verticalCenterImageAndTitleWithSpacing:(float)spacing;

/*
 * 自动计算 Button size
 */
- (CGSize)tm_sizeThatFits;

@end
