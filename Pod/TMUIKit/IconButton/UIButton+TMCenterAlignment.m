//
//  UIButton+TMCenterAlignment.m
//  TMUIKit-TMUIKit
//
//  Created by LinXiaoBin on 2018/9/10.
//

#import "UIButton+TMCenterAlignment.h"
#import <TMCategories2/TMCategories.h>
#import <objc/runtime.h>

typedef NS_ENUM(NSInteger, TMIconButtonDirection) {
    TMIconButtonDirectionHorizontal = 0,
    TMIconButtonDirectionVertical,
};


@interface UIButton()

@property (nonatomic, assign) CGFloat tm_horizontalSpace;
@property (nonatomic, assign) CGFloat tm_verticalSpace;
@property (nonatomic, assign) TMIconButtonDirection tm_iconDirection;

@end


@implementation UIButton (TMCenterAlignment)

- (CGFloat)tm_horizontalSpace
{
    return [objc_getAssociatedObject(self, @selector(tm_horizontalSpace)) floatValue];
}

- (void)setTm_horizontalSpace:(CGFloat)tm_horizontalSpace
{
    objc_setAssociatedObject(self, @selector(tm_horizontalSpace), @(tm_horizontalSpace), OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)tm_verticalSpace
{
    return [objc_getAssociatedObject(self, @selector(tm_verticalSpace)) floatValue];
}

- (void)setTm_verticalSpace:(CGFloat)tm_verticalSpace
{
    objc_setAssociatedObject(self, @selector(tm_verticalSpace), @(tm_verticalSpace), OBJC_ASSOCIATION_ASSIGN);
}

- (TMIconButtonDirection)tm_iconDirection
{
    return [objc_getAssociatedObject(self, @selector(tm_iconDirection)) integerValue];
}

- (void)setTm_iconDirection:(TMIconButtonDirection)tm_iconDirection
{
    objc_setAssociatedObject(self, @selector(tm_iconDirection), @(tm_iconDirection), OBJC_ASSOCIATION_ASSIGN);
}


/*
 Note:
 
 defaults image left and title right, no spacing.
 
 imageEdgeInsets (top left bottom right) is the offset relative to titleLabel
 
 titleEdgeInsets (top left bottom right) is the offset relative to imageView
 
 忽删!!!
 */

/**
 *  水平居中按钮 image 和 title
 *
 *  @param spacing - image 和 title 的水平间距, 单位point
 */
- (void)tm_horizontalCenterImageAndTitleWithSpacing:(float)spacing
{
    self.tm_horizontalSpace = spacing;
    self.tm_iconDirection = TMIconButtonDirectionHorizontal;

    // left the image
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, -spacing, 0.0, 0.0);

    // right the text
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, -spacing);
}

/**
 *  水平居中按钮 title 和 image
 *
 *  @param spacing - image 和 title 的水平间距, 单位point
 */
- (void)tm_horizontalCenterTitleAndImageWithSpacing:(float)spacing
{
    self.tm_horizontalSpace = spacing;
    self.tm_iconDirection = TMIconButtonDirectionHorizontal;

    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = [self.titleLabel.text boundingRectWithSize:self.bounds.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.titleLabel.font} context:nil].size;

    // get the width they will take up as a unit
    CGFloat totalWidth = (imageSize.width + titleSize.width + spacing);

    // right the image
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, -(totalWidth - imageSize.width) * 2 + spacing);

    // left the text
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -(totalWidth - titleSize.width) * 2 + spacing, 0.0, 0.0);
}

/**
 *  垂直居中按钮 image 和 title
 *
 *  @param spacing - image 和 title 的垂直间距, 单位point
 */
- (void)tm_verticalCenterImageAndTitleWithSpacing:(float)spacing
{
    self.tm_verticalSpace = spacing;
    self.tm_iconDirection = TMIconButtonDirectionVertical;

    // get the size of the elements here for readability
    CGSize imageSize = self.imageView.frame.size;
    //    CGSize titleSize = self.titleLabel.frame.size;
    CGSize titleSize = [self.titleLabel.text boundingRectWithSize:self.bounds.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.titleLabel.font} context:nil].size;
    // get the height they will take up as a unit
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);

    // raise the image and push it right to center it
    self.imageEdgeInsets = UIEdgeInsetsMake(-(totalHeight - imageSize.height), 0.0, 0.0, -titleSize.width);

    // lower the text and push it left to center it
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(totalHeight - titleSize.height), 0.0);
}


/*
 * 自动计算 Button size
 */
- (CGSize)tm_sizeThatFits
{
    CGFloat width = self.width;
    CGFloat height = self.height;
    if (self.tm_iconDirection == TMIconButtonDirectionHorizontal) {
        width = self.imageView.width + self.titleLabel.width + self.tm_horizontalSpace + self.contentEdgeInsets.left + self.contentEdgeInsets.right;
        height = MAX(self.imageView.height, self.titleLabel.height) + self.contentEdgeInsets.top + self.contentEdgeInsets.bottom;
    } else {
        width = MAX(self.imageView.width, self.titleLabel.width) + self.contentEdgeInsets.left + self.contentEdgeInsets.right;
        ;
        height = self.imageView.height + self.titleLabel.height + self.tm_verticalSpace + self.contentEdgeInsets.top + self.contentEdgeInsets.bottom;
    }

    return CGSizeMake(width, height);
}

@end
