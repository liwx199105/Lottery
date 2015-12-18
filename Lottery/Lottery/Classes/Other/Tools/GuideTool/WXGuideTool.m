//
//  WXGuideTool.m
//  28-网易彩票
//
//  Created by 李伟雄 on 15/12/18.
//  Copyright © 2015年 Liwx. All rights reserved.
//

#import "WXGuideTool.h"
#import <UIKit/UIKit.h>

@implementation WXGuideTool

#define kSystemVersion @"WXVersion"

+ (BOOL)isNewVersion
{
    // 获取当前版本号
    NSString *curVersion = [self getCurVersion];
    // 获取上一个版本号
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] valueForKeyPath:kSystemVersion];
    
    NSLog(@"%@, %@", curVersion, lastVersion);
    
    // 若无新版本,则返回
    if ([curVersion isEqualToString:lastVersion]) return NO;

    // 有新版本,更新lastVersion版本号
    [[NSUserDefaults standardUserDefaults] setObject:curVersion forKey:kSystemVersion];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;

}

+ (NSString *)getCurVersion
{
    return [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
}

@end
