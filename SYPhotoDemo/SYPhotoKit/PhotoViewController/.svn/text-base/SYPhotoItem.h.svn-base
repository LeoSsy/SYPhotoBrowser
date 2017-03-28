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
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface PhotoGroup : NSObject

/**每一组的封面图*/
@property(nonatomic,strong)UIImage *coverImage;

/**组名*/
@property(nonatomic,strong)NSString *groupName;

/**组对应图片数*/
@property(nonatomic,assign)NSInteger count;//相册个数

/**相册组结果集*/
@property(nonatomic,strong)PHFetchResult *fetchResult;

/**组对应图片数*/
@property(nonatomic,strong)NSArray *images;// 里面存储 SYPhotoItem

/**
 *  快速构建组对象
 *
 *  @param name        组名
 *  @param fetchResult 对应的相册结果集
 *
 *  @return 返回创建好的相册组
 */
+ (instancetype)groupWithName:(NSString*)name result:(id)fetchResult;

@end


@interface SYPhotoItem : NSObject

/**高清图片的地址*/
@property(nonatomic,strong)NSString *url;

/** 照片的方向 */
@property (nonatomic, assign) UIImageOrientation imageOrientation;

/**图片名称*/
@property(nonatomic,strong)NSString *filename;

/**本地图像 缩略图*/
@property(nonatomic,strong)UIImage *image;

/**本地图像 高清图*/
@property(nonatomic,strong)UIImage *fullImage;

/**PHAsset对象*/
@property(nonatomic,strong)PHAsset *phasset;

/**ALAsset对象*/
@property(nonatomic,strong)ALAsset *alasset;

/**视频数据*/
@property(nonatomic,strong)NSData *videoData;

/**Asset对象*/
@property(nonatomic,strong)id asset;

/**图片的位置信息 纬度*/
@property(nonatomic,strong)CLLocation *location;

/**图片的拍摄时间*/
@property(nonatomic,strong)NSString *photoCreateDate;

/**图片的拍摄地点*/
@property(nonatomic,strong)NSString *address;

/**记录当前模型 是否选中*/
@property (assign, nonatomic) BOOL isSelected;

/**图片地址*/
@property(nonatomic,strong)NSString *filePath;

/**是否是默认占位图片*/
@property(nonatomic,assign,getter=isDefaultPlaceholder)BOOL defaultPlaceholder;

/**图片上传到服务器 对应的压缩尺寸 此字段是额外辅助字段*/
@property(nonatomic,assign)CGSize scaleSize;

/**
 获取原图
 @param completion 获取完成后的回调
 */
- (void)getOriginalImageWithCompletion:(void(^)(UIImage *image))completion;

@end
