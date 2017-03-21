//
//  UIView+TMSHUD.h
//  Tianmushan
//
//  Created by shushaoyong on 2016/11/11.
//  Copyright © 2016年 踏潮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (hud)

- (void)showError:(NSString *)title position:(id)postion;
- (void)showSucess:(NSString*)title;
- (void)showError:(NSString*)title;
- (void)showActivity;
- (void)hideActivity;

@end
