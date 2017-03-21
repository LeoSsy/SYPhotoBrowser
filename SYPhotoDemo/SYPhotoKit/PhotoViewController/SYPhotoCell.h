/**************************************************************************
 *
 *  Created by shushaoyong on 2016/10/27.
 *    Copyright © 2016年 踏潮. All rights reserved.
 *
 * 项目名称：浙江踏潮-天目山-h5模版制作软件
 * 版权说明：本软件属浙江踏潮网络科技有限公司所有，在未获得浙江踏潮网络科技有限公司正式授权
 *           情况下，任何企业和个人，不能获取、阅读、安装、传播本软件涉及的任何受知
 *           识产权保护的内容。
 ***************************************************************************/
#import <UIKit/UIKit.h>

@class SYPhotoItem,SYPhotoCell;

@protocol SYPhotoCellDelegate <NSObject>

@optional

/**点击图片预览 */
- (void)photoCellCoverDidSelected:(SYPhotoCell*)cell currentIndex:(NSInteger)currentIndex;
/**选中 */
- (void)photoCellDidSelected:(SYPhotoCell*)cell;
/**取消选中 */
- (void)photoCellCancleSelected:(SYPhotoCell*)cell;
@end

@interface SYPhotoCell : UICollectionViewCell

/**Photoitem 模型 */
@property(nonatomic,strong)SYPhotoItem *photoItem;
/**delegate*/
@property(nonatomic,weak)id<SYPhotoCellDelegate> delegate;
/**indexPath */
@property(nonatomic,strong)NSIndexPath *indexPath;
/**选择按钮*/
@property(nonatomic,strong)UIButton *selectBtn;
@end
