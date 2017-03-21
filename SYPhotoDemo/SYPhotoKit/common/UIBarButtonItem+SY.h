//
//  UIBarButtonItem+SY.h
//  Tianmushan
//
//  Created by shushaoyong on 2016/10/26.
//  Copyright © 2016年 踏潮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (TMSBarbutonItem)

+ (instancetype)barbuttonitemWithTitle:(NSString*)title target:(id)target action:(SEL)action;

+ (instancetype)leftBarbuttonitemWithTitle:(NSString*)title target:(id)target action:(SEL)action;

@end
