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

@class SYPhotoViewController,PhotoGroup;

@protocol SYPhotoViewControllerDelegate <NSObject>

@optional

/**
 *  点击完成选择的时候调用
 *
 *  @param vc         self
 *  @param photoItems 选中的所有的照片
 */
- (void)photoViewController:(SYPhotoViewController*)vc didFinishSYPhotoItem:(NSArray*)photoItems;


/**
 *  点击了一个图片的时候调用
 *
 *  @param vc         self
 *  @param photoItems 当前显示的所有的照片
 *  @param index      当前图片对应的index
 */
- (void)photoViewController:(SYPhotoViewController*)vc didClickedItemIndex:(NSInteger)index items:(NSArray*)photoItems;

/**
 *  取消的时候调用
 *
 *  @param vc 相册控制器
 */
- (void)photoViewControllerCancle:(SYPhotoViewController*)vc;

@end

@interface SYPhotoViewController : UIViewController
/**最多选择多少张*/
@property(nonatomic,assign)NSInteger maxSelectedNum;
/**是否需要放大动画*/
@property(nonatomic,assign,getter=isAnimating)BOOL animating;
/**delegate*/
@property(nonatomic,weak)id<SYPhotoViewControllerDelegate>photoDelegate;
/**相册组*/
@property(nonatomic,strong)PhotoGroup *groupResult;
/**此属性设置为true 则只加载视频 不加载图片*/
@property(nonatomic,assign)BOOL videoEnabled;
@end


