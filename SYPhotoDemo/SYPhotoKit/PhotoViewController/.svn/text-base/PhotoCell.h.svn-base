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

@class PhotoItem,PhotoCell;

@protocol PhotoCellDelegate <NSObject>

@optional

/**点击图片预览 */
- (void)photoCellCoverDidSelected:(PhotoCell*)cell currentIndex:(NSInteger)currentIndex;

/**选中 */
- (void)photoCellDidSelected:(PhotoCell*)cell;

/**取消选中 */
- (void)photoCellCancleSelected:(PhotoCell*)cell;

@end


@interface PhotoCell : UICollectionViewCell

/**Photoitem 模型 */
@property(nonatomic,strong)PhotoItem *photoItem;

/**delegate*/
@property(nonatomic,weak)id<PhotoCellDelegate> delegate;

/**indexPath */
@property(nonatomic,strong)NSIndexPath *indexPath;

/**选中按钮*/
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;



@end
