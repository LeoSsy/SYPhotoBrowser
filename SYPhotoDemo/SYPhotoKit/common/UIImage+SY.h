//
//  UIImage+SY.h
//  photo
//
//  Created by shushaoyong on 2016/10/24.
//  Copyright © 2016年 踏潮. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (SY)

/**
 *   返回应用的启动图片
 */
+ (UIImage *)launchImage;

    
/**
 *   通过颜色返回一张图片
 */
+(UIImage*) createImageWithColor:(UIColor*) color;

/**
 *   由图片与矩形区域获得一张裁剪后的图片
 */
- (UIImage *)clipByRect:(CGRect)rect;

/**
 *  通过一个图片对象获得一张一模一样的新图片
 *
 *  @return <#return value description#>
 */
- (UIImage *)orignalNewImage;


/**
 *  压缩图片到指定尺寸 1280*960
 *
 *  @param item <#item description#>
 *
 *  @return <#return value description#>
 */
+ (UIImage*)resizeImage1280WithItem:(UIImage*)item;

/**
 *  改变图片的方向
 *
 *  @return <#return value description#>
 */
- (UIImage *)changeImageOrientation;


/**
 *根据给定的size的宽高比自动缩放原图片、自动判断截取位置,进行图片截取
 * UIImage image 原始的图片
 * CGSize size 截取图片的size
 */
+(UIImage *)clipImage:(UIImage *)image toRect:(CGSize)size;
    
@end
