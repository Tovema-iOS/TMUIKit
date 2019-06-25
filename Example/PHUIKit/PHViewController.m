//
//  PHViewController.m
//  PHUIKit
//
//  Created by linxiaobin on 03/22/2016.
//  Copyright (c) 2016 linxiaobin. All rights reserved.
//

#import "PHViewController.h"
#import <TMUIKit/TMUIKit.h>
#import "TestImageButtonViewController.h"
#import <CYLDeallocBlockExecutor/CYLDeallocBlockExecutor.h>

#define kSectionTitleKey @"SectionTitle"
#define kCellTitleArrayKey @"CellTitleArray"
#define kCellTitleKey @"Title"
#define kCellOperationKey @"Operation"

@interface PHViewController()

@property (nonatomic, strong) NSMutableArray *sections;

@end

@implementation PHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    self.sections = [NSMutableArray array];
    {
        NSMutableArray *array = [NSMutableArray array];

        __block typeof(self) weakSelf = self;
        [array addObject:@{kCellTitleKey: @"Toast", kCellOperationKey: [NSBlockOperation blockOperationWithBlock:^{
                               [weakSelf testToast];
                           }]}];

        [array addObject:@{kCellTitleKey: @"Icon Button", kCellOperationKey: [NSBlockOperation blockOperationWithBlock:^{
                               TestImageButtonViewController *ctrl = [[TestImageButtonViewController alloc] init];
                               [weakSelf.navigationController pushViewController:ctrl animated:YES];
                           }]}];

        [array addObject:@{kCellTitleKey: @"WebView v2", kCellOperationKey: [NSBlockOperation blockOperationWithBlock:^{
                               NSString *url = @"http://www.baidu.com";
                               TMWebViewController *ctrl = [[TMWebViewController alloc] initWithURLString:url];
                               ctrl.showWebTitle = YES;

                               [weakSelf.navigationController pushViewController:ctrl animated:YES];
                           }]}];


        [self.sections addObject:@{kSectionTitleKey: @"测试",
                                   kCellTitleArrayKey: array}];
    }

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DefaultCellIDentifier"];

#if kSideMenuFlag
    [self createNavigationItem];
#endif
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

#if 0
#warning 测试
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
        if (indexPath.section < [self numberOfSectionsInTableView:self.tableView]
            && indexPath.row < [self tableView:self.tableView numberOfRowsInSection:indexPath.section]) {
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
        }
#endif
    });
}

#pragma mark - Private

- (void)testToast
{
    CYLDeallocSelfCallback deallocCallback = ^(__unsafe_unretained id owner, NSUInteger identifier) {
        NSLog(@"%@ dealloc", owner);
    };

    TMToast *toast = nil;
    toast = TMToast.toast().setMessage(@"1").setShowTime(1).showTo(self.view);
    [toast cyl_willDeallocWithSelfCallback:deallocCallback];
    [toast.messageView cyl_willDeallocWithSelfCallback:deallocCallback];

    toast = TMToast.toast().setMessage(@"长消息消息消息消息消息消息消息消息消息消息消息消息消息消息").setShowTime(2).showTo(self.view);
    [toast cyl_willDeallocWithSelfCallback:deallocCallback];

    //    TMToast.toast().clear().setMessage(@"Loading...").setShowTime(0).setModal(YES).showTo(self.view);
    TMToast.toast().setMessage(@"Loading...").setShowTime(2).setActivityIndicatorStyle(TMToastIndicatorWhite).setModal(YES).showTo(self.view);
    [toast cyl_willDeallocWithSelfCallback:deallocCallback];
    TMToast.toast().setMessage(@"Loading...").setShowTime(0).setActivityIndicatorStyle(TMToastIndicatorWhiteLarge).setModal(YES).showTo(self.view);
    [toast cyl_willDeallocWithSelfCallback:deallocCallback];

    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [TMToast clear];
    //    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *dict = [self.sections objectAtIndex:section];
    if ([dict isKindOfClass:[NSDictionary class]]) {
        return dict[kSectionTitleKey];
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dict = [self.sections objectAtIndex:section];
    if ([dict isKindOfClass:[NSDictionary class]]) {
        return [dict[kCellTitleArrayKey] count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCellIDentifier" forIndexPath:indexPath];

    NSDictionary *dict = [self.sections objectAtIndex:indexPath.section];
    NSArray *titles = dict[kCellTitleArrayKey];
    if ([titles isKindOfClass:[NSArray class]]) {
        NSDictionary *cellDict = titles[indexPath.row];
        if ([dict isKindOfClass:[NSDictionary class]]) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@-%@ %@", @(indexPath.section), @(indexPath.row), cellDict[kCellTitleKey]];
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSDictionary *dict = [self.sections objectAtIndex:indexPath.section];
    NSArray *titles = dict[kCellTitleArrayKey];
    if ([titles isKindOfClass:[NSArray class]]) {
        NSDictionary *cellDict = titles[indexPath.row];
        if ([dict isKindOfClass:[NSDictionary class]]) {
            NSBlockOperation *operation = cellDict[kCellOperationKey];
            for (void (^block)(void) in operation.executionBlocks) {
                block();
            }
        }
    }
}

@end
