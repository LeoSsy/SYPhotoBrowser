/**************************************************************************
 *
 *  Created by shushaoyong on 2016/11/11.
 *    Copyright © 2016年 踏潮. All rights reserved.
 *
 * 项目名称：浙江踏潮-天目山-h5模版制作软件
 * 版权说明：本软件属浙江踏潮网络科技有限公司所有，在未获得浙江踏潮网络科技有限公司正式授权
 *           情况下，任何企业和个人，不能获取、阅读、安装、传播本软件涉及的任何受知
 *           识产权保护的内容。
 *
 ***************************************************************************/

#import "SYPhotoLibraryTool.h"
#import <AssetsLibrary/AssetsLibrary.h>

/** 8.0+ 使用Photos类库 */
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0

#import <Photos/Photos.h>
#endif
#import "SYPhotoItem.h"
#import "SYPhotoConst.h"

@interface SYPhotoLibraryTool()

/**相册组数组*/
@property(nonatomic,strong)NSMutableArray *groups;

/**图片资源器*/
@property (nonatomic, strong)  ALAssetsLibrary * assetLibrary;

/**图片缓存管理者*/
@property(nonatomic,strong)PHCachingImageManager *cachingImageManager;

@end

@implementation SYPhotoLibraryTool

#pragma mark 懒加载方法
- (ALAssetsLibrary *)assetLibrary
{
    if (!_assetLibrary) {
        _assetLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetLibrary;
}
- (PHCachingImageManager *)cachingImageManager {
    
    if (!_cachingImageManager) {
        _cachingImageManager = [[PHCachingImageManager alloc] init];
    }
    return _cachingImageManager;
}
- (NSMutableArray *)groups
{
    if (!_groups) {
        _groups = [NSMutableArray array];
    }
    return  _groups;
}


+ (instancetype) sharedInstance{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

/**
 *获取相册权限
 *authorized 是否有权限
 */
- (void)getPhotoAuthorized:(void (^)(BOOL authorized))completion
{
    
}


/**
 *  加载相册库
 *
 *  @param completions 完成之后的回调
 */
- (void)photoLibraryItemsMultiGroup:(BOOL)multiGroup Completions:(void(^)(NSMutableArray* groups))completions;
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (IsIOS8) {
            //判断状态
            if ([PHPhotoLibrary  authorizationStatus] == PHAuthorizationStatusDenied) {
                return;
            }
            //加载相册
            [self ios8LoadPhotosMultiGroup:multiGroup Completion:^(NSMutableArray *groups) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completions) {
                        completions(groups);
                    }
                });
            }];
        }else{ //ios8系统以下
            //判断状态
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                return;
            }
            //加载相册
            [self ios7LoadPhotosMultiGroup:multiGroup Completion:^(NSMutableArray *groups) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completions) {
                        completions(groups);
                    }
                });
            }];
        }
    });
}

/**
 *  iOS7加载系统相册方法
 */
- (void)ios7LoadPhotosMultiGroup:(BOOL)multiGroup Completion:(void(^)(NSMutableArray* groups))completions
{
    [self.assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group == nil) {
            NSLog(@"group nil will do it");
            /** fix bug before iOS8 will crash because here will be called twice */
            *stop = YES;
        }
        if ([group numberOfAssets] < 1) return;
        NSString *name = [group valueForProperty:ALAssetsGroupPropertyName];
        //如果不需要加载多组
        if (!multiGroup) {
            if ([name isEqualToString:@"Camera Roll"] || [name isEqualToString:@"全部照片"]) {
                [self.groups insertObject:[PhotoGroup groupWithName:name result:group] atIndex:0];
                *stop = YES;
            }
        }else{  //如果需要加载多组
            if ([name isEqualToString:@"Camera Roll"] || [name isEqualToString:@"全部照片"]) {
                [self.groups insertObject:[PhotoGroup groupWithName:name result:group] atIndex:0];
            } else if ([name isEqualToString:@"My Photo Stream"] || [name isEqualToString:@"我的照片流"]) {
                [self.groups insertObject:[PhotoGroup groupWithName:name result:group] atIndex:1];
            } else {
                [self.groups addObject:[PhotoGroup groupWithName:name result:group]];
            }
        }
        if (stop) {
            completions?completions(self.groups):nil;
        }
    } failureBlock:^(NSError *error) {
        completions?completions(self.groups):nil;
    }];
}

/**
 *  ios8以后加载相册的方法
 *
 *  @param completions 成功之后的回调
 */
- (void)ios8LoadPhotosMultiGroup:(BOOL)multiGroup Completion:(void(^)(NSMutableArray* groups))completions
{
    weakifySelf
    //清空原来的所有的资源 重新添加
    [self.groups removeAllObjects];
    
    /** 获取只能相册，过滤其中图片为0的 */
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    //如果不需要加载多组
    if (multiGroup==NO) {
        [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *collection  , NSUInteger idx, BOOL * _Nonnull stop) {
            strongifySelf
            /** 修改pickingVideoEnable功能为 只选择视频 */
            PHFetchOptions *option = [[PHFetchOptions alloc] init];
            option.predicate =[NSPredicate predicateWithFormat:@"mediaType=%ld", PHAssetMediaTypeImage];
            // 针对 PHAsset 的谓词过滤才可以使用 mediaType
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            if (fetchResult.count > 0 && ([collection.localizedTitle isEqualToString:@"Camera Roll"]|| [collection.localizedTitle isEqualToString:@"相机胶卷"]) ) {
                //如果是相机胶卷
                [self.groups addObject:[PhotoGroup groupWithName:@"全部照片" result:[fetchResult copy]]];
                *stop = YES;
            }
        }];
        completions?completions(self.groups):nil;
    }else{ //如果需要加载多组
        [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *collection  , NSUInteger idx, BOOL * _Nonnull stop) {
            strongifySelf
            /** 修改pickingVideoEnable功能为 只选择视频 */
            PHFetchOptions *option = [[PHFetchOptions alloc] init];
            option.predicate =[NSPredicate predicateWithFormat:@"mediaType=%ld", PHAssetMediaTypeImage];
            // 针对 PHAsset 的谓词过滤才可以使用 mediaType
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            if (fetchResult.count > 0 && ([collection.localizedTitle isEqualToString:@"Camera Roll"]|| [collection.localizedTitle isEqualToString:@"相机胶卷"]) ) {
                //如果是相机胶卷
                [self.groups addObject:[PhotoGroup groupWithName:@"全部照片" result:[fetchResult copy]]];
                *stop = YES;
            }
        }];
        /** 获取普通相册，过滤其中图片为0的 */
        PHFetchResult *albums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
        for (PHAssetCollection *collection in albums) {
            
            /** 修改pickingVideoEnable功能为 只选择视频 */
            PHFetchOptions *option = [[PHFetchOptions alloc] init];
            option.predicate =[NSPredicate predicateWithFormat:@"mediaType = %ld", PHAssetMediaTypeImage];
            
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            if (fetchResult.count < 1) continue;
            if ([collection.localizedTitle isEqualToString:@"My Photo Stream"]) {
                [self.groups insertObject:[PhotoGroup groupWithName:collection.localizedTitle result:[fetchResult copy] ] atIndex:1];
            } else {
                [self.groups addObject:[PhotoGroup groupWithName:[collection.localizedTitle copy] result:[fetchResult copy]]];
            }
        }
        //        /** 增加了根据相册内图片数量排序功能 */
        [self.groups sortUsingComparator:^NSComparisonResult(PhotoGroup  *obj1, PhotoGroup *obj2) {
            if (obj1.count >= obj2.count) {
                return NSOrderedAscending;
            }else {
                return NSOrderedDescending;
            }
        }];
        completions?completions(self.groups):nil;
    }
}

/**
 *  ios8以后加载相册视频的方法
 *  @param completions 成功之后的回调
 */
- (void)ios8LoadVideosMultiGroup:(BOOL)multiGroup Completion:(void(^)(NSMutableArray* groups))completions
{
    weakifySelf
    
    //清空原来的所有的资源 重新添加
    [self.groups removeAllObjects];
    
    /** 获取只能相册，过滤其中图片为0的 */
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    //如果不需要加载多组
    if (multiGroup==NO) {
        [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *collection  , NSUInteger idx, BOOL * _Nonnull stop) {
            strongifySelf
            NSLog(@"%@",collection.localizedTitle);
            /** 修改pickingVideoEnable功能为 只选择视频 */
            PHFetchOptions *option = [[PHFetchOptions alloc] init];
            option.predicate =[NSPredicate predicateWithFormat:@"mediaType=%ld", PHAssetMediaTypeVideo];
            // 针对 PHAsset 的谓词过滤才可以使用 mediaType
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            if (fetchResult.count > 0 && ([collection.localizedTitle isEqualToString:@"Camera Roll"]) ) {
                //如果是相机胶卷
                [self.groups addObject:[PhotoGroup groupWithName:@"全部视频" result:[fetchResult copy]]];
                *stop = YES;
            }
        }];
        completions?completions(self.groups):nil;
    }else{ //如果需要加载多组
        [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *collection  , NSUInteger idx, BOOL * _Nonnull stop) {
            strongifySelf
            /** 修改pickingVideoEnable功能为 只选择视频 */
            PHFetchOptions *option = [[PHFetchOptions alloc] init];
            option.predicate =[NSPredicate predicateWithFormat:@"mediaType=%ld", PHAssetMediaTypeVideo];
            // 针对 PHAsset 的谓词过滤才可以使用 mediaType
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            if (fetchResult.count > 0 && ([collection.localizedTitle isEqualToString:@"Camera Roll"])) {
                //如果是相机胶卷
                [self.groups addObject:[PhotoGroup groupWithName:@"全部视频" result:[fetchResult copy]]];
                *stop = YES;
            }
        }];
        /** 获取普通相册，过滤其中图片为0的 */
        PHFetchResult *albums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        for (PHAssetCollection *collection in albums) {
            /** 修改pickingVideoEnable功能为 只选择视频 */
            PHFetchOptions *option = [[PHFetchOptions alloc] init];
            option.predicate =[NSPredicate predicateWithFormat:@"mediaType = %ld", PHAssetMediaTypeVideo];
            
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            if (fetchResult.count < 1) continue;
            if ([collection.localizedTitle isEqualToString:@"My Photo Stream"]) {
                [self.groups insertObject:[PhotoGroup groupWithName:collection.localizedTitle result:[fetchResult copy] ] atIndex:1];
            } else {
                [self.groups addObject:[PhotoGroup groupWithName:[collection.localizedTitle copy] result:[fetchResult copy]]];
            }
        }
        //* 增加了根据相册内图片数量排序功能
        [self.groups sortUsingComparator:^NSComparisonResult(PhotoGroup  *obj1, PhotoGroup *obj2) {
            if (obj1.count >= obj2.count) {
                return NSOrderedAscending;
            }else {
                return NSOrderedDescending;
            }
        }];
        completions?completions(self.groups):nil;
    }
}

/**
 根据asset获取视频
 @param asset PHAsset 对象
 @param result 成功的回调
 */
+ (void)getVideoFromPHAsset:(PHAsset *)asset Complete:(void(^)(NSData *data,NSString *fileName))result {
    NSArray *assetResources = [PHAssetResource assetResourcesForAsset:asset];
    PHAssetResource *resource;
    for (PHAssetResource *assetRes in assetResources) {
        if (assetRes.type == PHAssetResourceTypePairedVideo ||
            assetRes.type == PHAssetResourceTypeVideo) {
            resource = assetRes;
        }
    }
    NSString *fileName = @"";
    if (resource.originalFilename) {
        fileName = resource.originalFilename;
    }
    
    if (asset.mediaType == PHAssetMediaTypeVideo || asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        NSString *PATH_MOVIE_FILE = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
        [[NSFileManager defaultManager] removeItemAtPath:PATH_MOVIE_FILE error:nil];
        [[PHAssetResourceManager defaultManager] writeDataForAssetResource:resource
                                                                    toFile:[NSURL fileURLWithPath:PATH_MOVIE_FILE]
                                                                   options:nil
                                                         completionHandler:^(NSError * _Nullable error) {
                                                             if (error) {
                                                                 result(nil, nil);
                                                             } else {
                                                                 
                                                                 NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:PATH_MOVIE_FILE]];
                                                                 result(data, PATH_MOVIE_FILE);
                                                             }
                                                             [[NSFileManager defaultManager] removeItemAtPath:PATH_MOVIE_FILE  error:nil];
                                                         }];
    } else {
        result(nil, nil);
    }
}




/**
 *  获取相册中的所有图片,视频
 *
 *  @param result             对应相册  PHFetchResult or ALAssetsGroup<ALAsset>
 *  @param completionBlock    回调block
 */
- (void)getAllAssetsFromResult:(id _Nonnull)result completionBlock:(void(^_Nonnull)(NSArray<SYPhotoItem *> * _Nullable assets))completionBlock {
    //创建数组保存获取到的图片
    NSMutableArray *photoArr = [NSMutableArray array];
    if ([result isKindOfClass:[PHFetchResult class]]) {
        PHFetchResult *fetchResult = (PHFetchResult*)result;
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.synchronous = YES;
        [fetchResult enumerateObjectsUsingBlock:^(PHAsset * _Nonnull asset, NSUInteger idx, BOOL * _Nonnull stop) {
            SYPhotoItem *item = [[SYPhotoItem alloc] init];
            item.phasset = asset;
            //添加图片到数组
            [photoArr addObject:item];
        }];
        completionBlock ? completionBlock(photoArr) : nil;
        
    } else if ([result isKindOfClass:[ALAssetsGroup class]]) {
        ALAssetsGroup *gruop = (ALAssetsGroup *)result;
        [gruop enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            /// Allow picking video
            if (result) {
                if (result.aspectRatioThumbnail != nil) {
                    SYPhotoItem *item = [[SYPhotoItem alloc] init];
                    item.alasset = result;
                    //添加图片到数组
                    [photoArr addObject:item];
                }
            }
        }];
        completionBlock ? completionBlock(photoArr) : nil;
    }
}

/**
 *  根据提供的asset 获取原图图片
 *  使用异步获取asset的原图图片
 *  @param asset           具体资源 <PHAsset or ALAsset>
 *  @param completionBlock 回到block
 */
- (void)getOriginImageWithAsset:(id)asset
                completionBlock:(void(^)(UIImage * image))completionBlock {
    
    __block UIImage *resultImage;
    if (IsIOS8) {
        PHImageRequestOptions *imageRequestOption = [[PHImageRequestOptions alloc] init];
        imageRequestOption.synchronous = YES;
        [self.cachingImageManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:imageRequestOption resultHandler:^(UIImage *  result, NSDictionary * info) {
            resultImage = result;
            completionBlock ? completionBlock(resultImage) : nil;
        }];
        
    } else {
        
        CGImageRef fullResolutionImageRef = [[(ALAsset *)asset defaultRepresentation] fullResolutionImage];
        // 通过 fullResolutionImage 获取到的的高清图实际上并不带上在照片应用中使用“编辑”处理的效果，需要额外在 AlAssetRepresentation 中获取这些信息
        NSString *adjustment = [[[(ALAsset *)asset defaultRepresentation] metadata] objectForKey:@"AdjustmentXMP"];
        if (adjustment) {
            // 如果有在照片应用中使用“编辑”效果，则需要获取这些编辑后的滤镜，手工叠加到原图中
            NSData *xmpData = [adjustment dataUsingEncoding:NSUTF8StringEncoding];
            CIImage *tempImage = [CIImage imageWithCGImage:fullResolutionImageRef];
            
            NSError *error;
            NSArray *filterArray = [CIFilter filterArrayFromSerializedXMP:xmpData
                                                         inputImageExtent:tempImage.extent
                                                                    error:&error];
            CIContext *context = [CIContext contextWithOptions:nil];
            if (filterArray && !error) {
                for (CIFilter *filter in filterArray) {
                    [filter setValue:tempImage forKey:kCIInputImageKey];
                    tempImage = [filter outputImage];
                }
                fullResolutionImageRef = [context createCGImage:tempImage fromRect:[tempImage extent]];
            }
        }
        // 生成最终返回的 UIImage，同时把图片的 orientation 也补充上去
        resultImage = [UIImage imageWithCGImage:fullResolutionImageRef
                                          scale:[[asset defaultRepresentation] scale]
                                    orientation:(UIImageOrientation)[[asset defaultRepresentation] orientation]];
        completionBlock ? completionBlock(resultImage) : nil;
    }
}


/**
 *  根据提供的asset获取缩略图
 *  使用同步方法获取
 *  @param asset           具体的asset资源 PHAsset or ALAsset
 *  @param size            缩略图大小
 *  @param completionBlock 回调block
 */
- (void)getThumbnailWithAsset:(id)asset
                         size:(CGSize)size
              completionBlock:(void(^)(UIImage * image))completionBlock {
    if (IsIOS8) {
        PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
        imageRequestOptions.synchronous = YES;        
        // 在 PHImageManager 中，targetSize 等 size 都是使用 px 作为单位，因此需要对targetSize 中对传入的 Size 进行处理，宽高各自乘以 ScreenScale，从而得到正确的图片
        CGFloat screenScale = [UIScreen mainScreen].scale;
        [self.cachingImageManager requestImageForAsset:asset targetSize:CGSizeMake(size.width * screenScale, size.height * screenScale) contentMode:PHImageContentModeAspectFit options:imageRequestOptions resultHandler:^(UIImage * result, NSDictionary * info) {
            completionBlock ? completionBlock(result) : nil;
        }];
        
    } else {
        /** 判断下尺寸 是否符合一个thumb 尺寸 */
        UIImage *thumbnail = [UIImage imageWithCGImage:[asset thumbnail]];
        if (size.width <= thumbnail.size.width && size.height <= thumbnail.size.height) {
            completionBlock ? completionBlock(thumbnail) : nil;
        }else {
            [self getOriginImageWithAsset:asset completionBlock:^(UIImage * _Nullable image) {
                /** 或者直接返回原图 */
                completionBlock ? completionBlock(image) : nil;
            }];
        }
    }
}


/**
 *  根据asset 获取屏幕预览图
 *
 *  @param asset           提供的asset资源 PHAsset or ALAsset
 *  @param completionBlock 回调block
 */
- (void)getPreviewImageWithAsset:(id)asset
                 completionBlock:(void(^)(UIImage * image))completionBlock {
    [self getThumbnailWithAsset:asset size:[UIScreen mainScreen].bounds.size completionBlock:completionBlock];
}

/**
 *  根据asset 获取图片地址 和 图片的方向
 *
 *  @param asset           提供的asset资源 PHAsset or ALAsset
 *  @param completionBlock 回调block
 */
- (void)getImageAssetUrlWithAsset:(id)asset
                 completionBlock:(void(^)(NSString *  url,UIImageOrientation imageOrientation))completionBlock {
    if ([asset isKindOfClass:[PHAsset class]]) {
        
        PHImageRequestOptions *imageRequestOptions = [[PHImageRequestOptions alloc] init];
        imageRequestOptions.synchronous = YES;
        //这个方法获取的图片是原图高清图
        [self.cachingImageManager requestImageDataForAsset:asset options:imageRequestOptions resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            NSString *url = [[info objectForKey:@"PHImageFileURLKey"] absoluteString];
            UIImageOrientation imageOri =(UIImageOrientation)[info objectForKey:@"PHImageFileOrientationKey"];
            completionBlock(url,imageOri);
        }];
    }else if ([asset isKindOfClass:[ALAsset class]]) {
        ALAsset *alasset = (ALAsset*)asset;
        completionBlock([alasset.defaultRepresentation.url absoluteString],(UIImageOrientation)[alasset valueForProperty:ALAssetPropertyOrientation]);
    }
}




@end
