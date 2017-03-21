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

#import "SYPhotoViewController.h"
#import "SYPhotoCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "SYPhotoItem.h"
#import "PhotoBrowserController.h"
#import "SYPhotoLayout.h"
#import "SYPhotoConst.h"
#import "SYPhotoLibraryTool.h"
#import <MediaPlayer/MediaPlayer.h>


#define SYPhotoViewControllerScreenWidth  [UIScreen mainScreen].bounds.size.width

//每一个cell高度
const NSInteger photoViewcellHeight = 40;
//bottomview 的高度
const NSInteger bottomViewHeight = 50;

@interface SYPhotoViewController ()<SYPhotoCellDelegate,UICollectionViewDelegate,UICollectionViewDataSource,PHPhotoLibraryChangeObserver>

/**相册组*/
@property(nonatomic,strong)NSMutableArray *images;

/**相册组数组*/
@property(nonatomic,strong)NSMutableArray *groups;

/**用户选中的所有图片*/
@property(nonatomic,strong)NSMutableArray *selectedImages;

/**导航栏标题按钮*/
@property(nonatomic,weak)UIButton *titleBtn;

/**导航栏标题箭头*/
@property(nonatomic,weak)UIImageView *arrow;

/**导航栏关闭按钮*/
@property(nonatomic,weak)UIButton *closeBtn;

/**内容视图*/
@property(nonatomic,weak) UICollectionView *collectionView;

/**bottomview*/
@property(nonatomic,weak)UIView *bottomView;

/**hudView*/
@property(nonatomic,weak)UIView *hudView;

/**加载动画*/
@property(nonatomic,strong)UIActivityIndicatorView *indicatorView;

/**记录上一次选中的组*/
@property(nonatomic,strong)PhotoGroup *lastGroup;

/**视频播放器*/
@property(nonatomic,strong) MPMoviePlayerViewController *playerVc;

@end

@implementation SYPhotoViewController

static NSString * const reuseIdentifier = @"SYPhotoCell";

/**
*  所有相册组
*
*/
- (NSMutableArray *)groups
{
   if (!_groups) {
     _groups = [NSMutableArray array];
   }
    return  _groups;
}

/**
*  保存当前显示的所有图片
*
*/
- (NSMutableArray *)images
{
    if (!_images) {
    _images = [NSMutableArray array];
    }
    return _images;
}

/**
*  用户当前选中的图片
*
*/
- (NSMutableArray *)selectedImages
{
    if (!_selectedImages) {
    _selectedImages = [NSMutableArray array];
    }
    return _selectedImages;
}

#pragma mark 控制器生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化操作
    [self setUp];
    //从相册获取照片
    [self loadPhotos];
}

/**
*  初始化方法
*/
- (void)setUp
{
    //设置导航栏
    [self setUpNavBar];
    //添加内容视图
    [self addCollectionview];
    //添加底部视图
    [self addBottomView];
    //添加加载视图
    [self addLoadView];
}

#pragma mark  设置导航栏
- (void)setUpNavBar
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = self.groupResult?self.groupResult.groupName:@"相机胶卷";
    CGFloat width = SYPhotoViewControllerScreenWidth;
    CGFloat height = 64;
    CGFloat btnwh = 40;
    UIButton *close = [[UIButton alloc] initWithFrame:CGRectMake(0,(height-btnwh)*0.5+10,btnwh, btnwh)];
    close.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [close setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:close];
    self.closeBtn = close;

    UIButton *rightClose = [[UIButton alloc] initWithFrame:CGRectMake(width-btnwh-10,(height-btnwh)*0.5+10,btnwh, btnwh)];
    [rightClose setTitle:@"取消" forState:UIControlStateNormal];
    [rightClose addTarget:self action:@selector(rightCloseClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightClose];
}

#pragma mark addCollectionview
-(void)addCollectionview
{
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[SYPhotoLayout alloc] init]];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    self.collectionView.backgroundColor = CUSTOMCOLOR(242, 242, 242);
    self.collectionView.contentInset = UIEdgeInsetsMake(10, 5, 64+bottomViewHeight, 5);
    self.collectionView.frame = self.view.bounds;
    //注册cell
    [self.collectionView registerClass:[SYPhotoCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

#pragma mark 底部工具栏
- (void)addBottomView
{
    CGFloat height = self.view.bounds.size.height-64;
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    bottomView.frame = CGRectMake(0, height - bottomViewHeight , SYPhotoViewControllerScreenWidth, bottomViewHeight);
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    
    CGFloat btnwh = bottomViewHeight;
    
    //如果不是视频选择 才添加预览按钮
    if (!self.videoEnabled) {
        UIButton *previewBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnwh, btnwh)];
        [previewBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [previewBtn setTitle:@"预览" forState:UIControlStateNormal];
        previewBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [previewBtn addTarget:self action:@selector(previewBtnClick) forControlEvents:UIControlEventTouchDown];
        [bottomView addSubview:previewBtn];
    }
 
    UIButton *finishBtn = [[UIButton alloc] initWithFrame:CGRectMake(SYPhotoViewControllerScreenWidth-btnwh, 0, btnwh, btnwh)];
    [finishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    finishBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [finishBtn addTarget:self action:@selector(finishBtnClick) forControlEvents:UIControlEventTouchDown];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [bottomView addSubview:finishBtn];
    
}

#pragma mark 添加网络加载的view
- (void)addLoadView
{
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    indicatorView.center = self.view.center;
    indicatorView.hidesWhenStopped = YES;
    [self.view addSubview:indicatorView];
    self.indicatorView = indicatorView;
}

/**
 *  设置相册组
 *
 *  @param groupResult 相册组数组
 */
- (void)setGroupResult:(PhotoGroup *)groupResult
{
    if (groupResult==nil) {
        return;
    }
    _groupResult = groupResult;
    [self.titleBtn setTitle:groupResult.groupName forState:UIControlStateNormal];
    [self.groups addObject:groupResult];
}


#pragma mark PHPhotoLibraryChangeObserver
/**
 *  重置所有按钮的状态
 */
- (void)resentSYPhotoItems
{
    for (PhotoGroup *group in self.groups) {
        for (SYPhotoItem *item in group.images) {
            item.isSelected = NO;
        }
    }
}


#pragma mark  从相册获取照片
- (void)loadPhotos
{
    [self.indicatorView startAnimating];
    [self loadPhotoDatas];
}

/**
*  iOS9加载系统相册方法
*/
- (void)loadPhotoDatas
{
    //如果是从相册组进入的 直接加载即可
    if (self.groupResult) {
        [self repeatGetPhotos];
        return;
    }
    //否则是第一次进入 重新加载相机胶卷的图片
    __weak typeof(self)weakself = self;
    [[SYPhotoLibraryTool sharedInstance] photoLibraryItemsMultiGroup:NO Completions:^(NSMutableArray *groups) {
        weakself.groups = [groups copy];
        [weakself repeatGetPhotos];
    }];
}

/**
 *  重新获取所有的照片数据
 */
- (void)repeatGetPhotos
{
    if (self.groups.count) {
        PhotoGroup *group = self.groups[0];
        if (group.images.count>0) {
            [self refreshPhotoDatas:group.images];
            return;
        }
        [[SYPhotoLibraryTool sharedInstance] getAllAssetsFromResult:group.fetchResult completionBlock:^(NSArray<SYPhotoItem *> *assets) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self refreshPhotoDatas:assets];
            });
        }];
    }
}


/**
 *  刷新相册数据
 *
 *  @param photos 相册数据
 */
- (void)refreshPhotoDatas:(NSArray*)photos
{
    //重置照片状态
    [self resentSYPhotoItems];
    //取出第一个相机胶卷的图片
    self.images = [photos mutableCopy];
    if (self.images.count>0) {
        [self.collectionView reloadData];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.images.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        [self.indicatorView stopAnimating];
        [self.indicatorView removeFromSuperview];
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    SYPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.photoItem = self.images[indexPath.row];
    cell.indexPath = indexPath;
    return cell;
}

#pragma mark SYPhotoCellDelegate
- (void)photoCellDidSelected:(SYPhotoCell *)cell
{
    if (self.selectedImages.count+1 > self.maxSelectedNum) {
        cell.selectBtn.selected = NO;
        cell.photoItem.isSelected = NO;
        if (self.maxSelectedNum>0) {
            if (self.videoEnabled) {
                [self.view showError:[NSString stringWithFormat:@"最多选择%zd个视频",self.maxSelectedNum]];
            }else{
                [self.view showError:[NSString stringWithFormat:@"最多选择%zd张图片",self.maxSelectedNum]];
            }
        }
        return;
    }
    //2. 将当前模型选中
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    SYPhotoItem *item = self.images[indexPath.row];
    [self.selectedImages addObject:item];
}

- (void)photoCellCancleSelected:(SYPhotoCell *)cell
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    SYPhotoItem *item = self.images[indexPath.row];
    [self.selectedImages removeObject:item];
}

- (void)photoCellCoverDidSelected:(SYPhotoCell *)cell currentIndex:(NSInteger)currentIndex
{
    SYPhotoItem *item = self.images[currentIndex];
    //如果是视频直接播放
    if (item.phasset.mediaType == PHAssetMediaTypeVideo || item.phasset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
        //获取视频的数据 并且播放
        [SYPhotoLibraryTool getVideoFromPHAsset:item.phasset Complete:^(NSData *data, NSString *fileName) {
                NSURL *url =  [NSURL fileURLWithPath:fileName];
                _playerVc = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
                [self presentMoviePlayerViewControllerAnimated:self.playerVc];
        }];
        
    }else{
        //打开图片浏览器
        NSMutableArray *temp = [NSMutableArray array];
        for (SYPhotoItem *photoitem in self.images) {
            PhotoBrowserItem *item = [[PhotoBrowserItem alloc] init];
            item.asset  = photoitem.asset;
            [temp addObject:item];
        }
        PhotoBrowserController *photoBrowser = [[PhotoBrowserController alloc] init];
        [self addChildViewController:photoBrowser];
        photoBrowser.images = temp;
        photoBrowser.currentIndex = currentIndex;
        photoBrowser.animating = NO;
        [self.navigationController pushViewController:photoBrowser animated:YES];
    }
}

#pragma mark  event
/**
 *  关闭事件
 */
- (void)close{
    if (self.navigationController) {
     [self.navigationController popViewControllerAnimated:YES];
    }else{
      [self dismissViewControllerAnimated:YES completion:nil];
    }
}

/**
 *  取消事件
 */
- (void)rightCloseClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SYPhotoVcCancleBtnClickNote object:nil];
}

/**
 底部预览按钮被点击了
 */
- (void)previewBtnClick
{
    if(self.selectedImages.count<=0)return;
    
    //打开图片浏览器
    NSMutableArray *temp = [NSMutableArray array];
    for (SYPhotoItem *photoitem in self.selectedImages) {
        PhotoBrowserItem *item = [[PhotoBrowserItem alloc] init];
        item.asset  = photoitem.asset;
        [temp addObject:item];
    }
    PhotoBrowserController *photoBrowser = [[PhotoBrowserController alloc] init];
    [self addChildViewController:photoBrowser];
    photoBrowser.images = temp;
    photoBrowser.currentIndex = 0;
    photoBrowser.animating = NO;
    [self.navigationController pushViewController:photoBrowser animated:YES];
}

/**
 底部完成按钮被点击了
 */
- (void)finishBtnClick
{
    //如果选择的是视频才需要此操作
    if (self.videoEnabled) {
        //获取当前选择视频的对应的视频数据
        for (SYPhotoItem *item in self.selectedImages) {
            //如果是视频直接播放
            if (item.phasset.mediaType == PHAssetMediaTypeVideo || item.phasset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
                //获取视频的数据 并且播放
                [SYPhotoLibraryTool getVideoFromPHAsset:item.phasset Complete:^(NSData *data, NSString *fileName) {
                    //保存视频路径和视频数据
                    item.videoData = data;
                }];
            }
        }
    }
    //发送取消完成的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:SYPhotoVcCancleBtnClickNote object:self.selectedImages];
}

/**
 *  当前控制器销毁的时候调用
 */
- (void)dealloc
{
    [[PHPhotoLibrary  sharedPhotoLibrary] unregisterChangeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end



