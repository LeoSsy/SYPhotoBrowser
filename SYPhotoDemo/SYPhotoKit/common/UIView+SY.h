//
//  UIView+SY.h
//  photo
//
//  Created by shushaoyong on 2016/10/24.
//  Copyright © 2016年 踏潮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SY)

/**
 *   返回视图的 X 坐标
 */
@property(nonatomic ,assign) CGFloat left;

/**
 *   返回视图的 Y 坐标
 */
@property(nonatomic ,assign) CGFloat top;

/**
 *   返回视图的长度
 */
@property(nonatomic ,assign) CGFloat width;

/**
 *   返回视图的高度
 */
@property(nonatomic ,assign) CGFloat height;

/**
 *   返回视图的右侧位置
 */
@property(nonatomic ,assign ,readonly) CGFloat right;

/**
 *   返回视图的底部位置
 */
@property(nonatomic ,assign ,readonly) CGFloat bottom;

/**
 *   返回视图的中心坐标
 */
@property(nonatomic ,assign) CGPoint center;


/**
 *   返回视图的中心X坐标
 */
@property(nonatomic ,assign) CGFloat centerX;


/**
 *   返回视图的中心Y坐标
 */
@property(nonatomic ,assign) CGFloat centerY;


/**
 *   返回视图的size
 */
@property(nonatomic ,assign) CGSize size;


@end
