/**************************************************************************
 *
 *  Created by shushaoyong on 2016/10/27.
 *    Copyright © 2016年 踏潮. All rights reserved.
 *
 * 项目名称：浙江踏潮-天目山-h5模版制作软件
 * 版权说明：本软件属浙江踏潮网络科技有限公司所有，在未获得浙江踏潮网络科技有限公司正式授权
 *           情况下，任何企业和个人，不能获取、阅读、安装、传播本软件涉及的任何受知
 *           识产权保护的内容。
 *
 ***************************************************************************/

#import <UIKit/UIKit.h>

@class PhotoBottomView,PhotoItem;

@protocol PhotoBottomViewDelegate <NSObject>

@optional

- (void)photoBottomViewFinishBtnDidClicked:(PhotoBottomView*)view;

@end

@interface PhotoBottomView : UIView

/**max 最多选择多少张*/
@property(nonatomic,assign)NSInteger maxNumber;

/**代理*/
@property(nonatomic,assign)id<PhotoBottomViewDelegate> delegate;

/**
 *  当前选择的照片
 *
 *  @param item   选中的照片模型
 *  @param number 选中的张数
 */
- (void)currentSelectedPhotoItem:(PhotoItem*)item number:(NSInteger)number;

/**
 *  当前取消选择的照片
 *
 *  @param item   选中的照片模型
 *  @param number 选中的张数
 */
- (void)cancleSelectedPhotoItem:(PhotoItem*)item number:(NSInteger)number;

@end


@class PhotoBottomViewCell;

@protocol PhotoBottomViewCellDelegate <NSObject>

@optional
- (void)PhotoBottomViewCellDeleteBtnDidClicked:(PhotoBottomViewCell*)cell item:(PhotoItem*)item;

@end
@interface PhotoBottomViewCell : UICollectionViewCell

/**代理*/
@property(nonatomic,assign)id<PhotoBottomViewCellDelegate> delegate;

/**代理*/
@property(nonatomic,strong)PhotoItem *item;

/**imageView*/
@property(nonatomic,weak) UIImageView *imageView;

@end

@interface PhotoBottomViewLayout : UICollectionViewFlowLayout

@end