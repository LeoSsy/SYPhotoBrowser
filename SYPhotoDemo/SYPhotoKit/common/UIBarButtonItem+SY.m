//
//  UIBarButtonItem+SY.m
//  Tianmushan
//
//  Created by shushaoyong on 2016/10/26.
//  Copyright © 2016年 踏潮. All rights reserved.
//

#import "UIBarButtonItem+SY.h"

@implementation UIBarButtonItem (TMSBarbutonItem)

+ (instancetype)barbuttonitemWithTitle:(NSString*)title target:(id)target action:(SEL)action
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 80, 44);
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    backButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [backButton setTitle:title forState:UIControlStateNormal];
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchDown];

    return [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
}

+ (instancetype)leftBarbuttonitemWithTitle:(NSString*)title target:(id)target action:(SEL)action
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 54, 44);
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    backButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [backButton setTitle:title forState:UIControlStateNormal];
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchDown];
    
    return [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
}


@end
