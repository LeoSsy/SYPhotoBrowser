/**************************************************************************
 *
 *  Created by shushaoyong on 2016/11/24.
 *    Copyright © 2016年 踏潮. All rights reserved.
 *
 * 项目名称：浙江踏潮-天目山-h5模版制作软件
 * 版权说明：本软件属浙江踏潮网络科技有限公司所有，在未获得浙江踏潮网络科技有限公司正式授权
 *           情况下，任何企业和个人，不能获取、阅读、安装、传播本软件涉及的任何受知
 *           识产权保护的内容。
 *
 ***************************************************************************/

#import <UIKit/UIKit.h>
typedef void(^completionBlock)(NSArray *items);
@interface SYPhotoGroupViewController : UITableViewController
/**照片或视频选择完成之后的回调*/
@property(nonatomic,strong) completionBlock didFinishcompletionBlock;
/**此属性设置为true 则只加载视频 不加载图片*/
@property(nonatomic,assign)BOOL videoEnabled;
/**导航栏 背景颜色*/
@property(nonatomic,strong)UIColor *navBgColor;
/**导航栏 文字颜色*/
@property(nonatomic,strong)UIColor *navTitleColor;
/**导航栏 标题大小*/
@property(nonatomic,strong)UIFont  *titleFont;
@end
@class PhotoGroup;
@interface SYPhotoGroupCell : UITableViewCell
/**相册组*/
@property(nonatomic,strong)PhotoGroup *group;
@end
