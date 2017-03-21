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

#import "PhotoBrowserController.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoLoadView.h"
#import "SYPhotoConst.h"
#import "SYPhotoLibraryTool.h"

#define PhotoBrowserControllerScreenWidth  [UIScreen mainScreen].bounds.size.width

@interface PhotoBrowserController ()<PhotoBrowserCellDelegate>

/**导航栏标题*/
@property(nonatomic,weak)UILabel *titleLabel;

/**返回按钮*/
@property(nonatomic,weak)UIButton *close;

/**保存图片下载队列*/
@property(nonatomic,strong)NSMutableDictionary *imageDequeues;

/**导航栏*/
@property(nonatomic,strong)UIView *navView;

@end

@implementation PhotoBrowserController

static NSString * const reuseIdentifier = @"PhotoBrowserCell";

- (instancetype)init
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height-0.1;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(width+16, height);
    if (self = [super initWithCollectionViewLayout:layout]) {
        self.collectionView.pagingEnabled = YES;
        self.collectionView.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

/**
 *  设置动画
 *
 *  @param animating 是否需要动画
 */
- (void)setAnimating:(BOOL)animating
{
    _animating = animating;
    
    if (animating) {
        self.navView.backgroundColor = [UIColor clearColor];
        self.close.hidden = YES;
    }
}

#pragma mark 初始化设置
- (void)setup
{
    
    [self addNavView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.collectionView.contentSize = CGSizeMake((PhotoBrowserControllerScreenWidth + 16) * self.images.count, SCREEN_HEIGHT);
    self.collectionView.frame = CGRectMake(0, 0, (PhotoBrowserControllerScreenWidth + 16), SCREEN_HEIGHT);
    [self.collectionView registerClass:[PhotoBrowserCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
}

#pragma mark  添加顶部导航栏
- (void)addNavView
{
    CGFloat width = PhotoBrowserControllerScreenWidth;
    CGFloat height = 64;
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    navView.backgroundColor = CUSTOMCOLOR(46, 46, 46);
    [self.view addSubview:navView];
    self.navView = navView;
    
    CGFloat btnwh = 40;
    UIButton *close =[[UIButton alloc] initWithFrame:CGRectMake(0,(height-btnwh)*0.5+10, btnwh, btnwh)];
    [close setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(closed) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:close];
    self.close = close;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((width-100)*0.5, (height-btnwh)*0.5+10, 100, btnwh)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"";
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor whiteColor];
    [navView addSubview:titleLabel];
    self.titleLabel = titleLabel;

    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 54, 44);
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    
}

BOOL selected = false;
/**
 *  当前屏幕单击事件
 */
- (void)tap
{
    selected = !selected;
    if (selected) {
        [UIView animateWithDuration:0.5 animations:^{
            self.navView.top = -64;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.navView.top = 0;
        } ];
    }
}

/**
 *  设置当前显示图片
 *
 *  @param currentIndex 当前图片的下标
 */
- (void)setCurrentIndex:(NSInteger)currentIndex
{
    self.titleLabel.text = [NSString stringWithFormat:@"%zd/%zd",(++currentIndex),self.images.count];

    [self showImageAtIndex:currentIndex];
}


#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.item = self.images[indexPath.row];
    cell.delegate = self;
    cell.indexPath = indexPath;
    return cell;
}


#pragma mark  scrollview offset

#pragma mark 获取当前的偏移量
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = offsetX/(PhotoBrowserControllerScreenWidth + 16);
    if (offsetX>0) {
        if (index<=0){
            index = 1;
        }else{
            index++;
        }
    }else if (offsetX<=0){
        index = 1;
    }
    self.titleLabel.text = [NSString stringWithFormat:@"%zd/%zd",index,self.images.count];
}

#pragma mark  showindex 显示对应位置的图片
- (void)showImageAtIndex:(NSInteger)index
{
    if (index>1){
        [self.collectionView setContentOffset:CGPointMake((index-1)*(PhotoBrowserControllerScreenWidth + 16), 0)];
    }
}


#pragma mark PhotoBrowserCellDelegate
- (void)photoBrowserCellImageClick:(PhotoBrowserCell *)cell indexPath:(NSIndexPath *)indexPath
{
    [self tap];
}

#pragma mark 关闭当前视图方法
-(void)closed
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

#define STPhotoPadding  16

@interface PhotoBrowserCell()<UIScrollViewDelegate>

/**scrollview*/
@property (nonatomic, strong) UIScrollView *scrollView;

/**容器视图*/
@property (nonatomic, strong) UIView *containerView;

/**网络图片正在加载的控件*/
@property(nonatomic,weak)PhotoLoadView *loadView;

/**本地相册正在加载的控件*/
@property(nonatomic,weak)UIActivityIndicatorView *indicatorView;

@end

@implementation PhotoBrowserCell

#pragma mark 设置界面数据
- (void)setItem:(PhotoBrowserItem *)item
{
    _item = item;

    self.indicatorView.hidden = NO;
    self.loadView.hidden = YES;
    [self.loadView showLoading];
    
    if ([item.imageUrl hasPrefix:@"http://"]) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:item.imageUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [self.loadView removeFromSuperview];
        }];
        return;
    }

    if ([[UIDevice currentDevice].systemVersion floatValue]<8.0) {

        ALAsset *asset = (ALAsset*)item.asset;
        self.imageView.image = [UIImage resizeImage1280WithItem:[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage]];
        [self.indicatorView stopAnimating];
        [self.indicatorView removeFromSuperview];

    }else{

        [self.contentView insertSubview:self.indicatorView aboveSubview:self.imageView];
        [self.indicatorView startAnimating];
        PHAsset *asset = (PHAsset*)item.asset;
        weakifySelf
        //异步加载图片
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            strongifySelf
            [[SYPhotoLibraryTool sharedInstance] getThumbnailWithAsset:asset size:CGSizeMake(asset.pixelWidth,asset.pixelHeight) completionBlock:^(UIImage *image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.imageView.image = image;
                    [self _resizeSubviews];
                    [self.indicatorView stopAnimating];
                    [self.indicatorView removeFromSuperview];
                });
            }];
        });
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _setup];
    }
    return self;
}

#pragma mark - Methods
/**
 *  创建界面控件
 */
- (void)_setup {
    
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [self.containerView addSubview:self.imageView];
    [self.scrollView addSubview:self.containerView];
    [self.contentView addSubview:self.scrollView];
    
    PhotoLoadView *loadView = [[PhotoLoadView alloc] init];
    loadView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:loadView];
    self.loadView = loadView;


    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-50)*0.5, (SCREEN_HEIGHT-50)*0.5, 50, 50)];
    
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self.contentView addSubview:indicatorView];
    self.indicatorView = indicatorView;

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleSingleTap)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self.contentView addGestureRecognizer:singleTap];
    [self.contentView addGestureRecognizer:doubleTap];
}

/**
 *  计算图片等比例尺寸
 */
- (void)_resizeSubviews {
    
    self.containerView.frame = self.bounds;
    UIImage *image = self.imageView.image;
    if (!image) {
        return;
    }
    CGFloat toHeight = image.size.height * (self.bounds.size.width - STPhotoPadding)/image.size.width;
    CGSize size = CGSizeMake(self.bounds.size.width - STPhotoPadding,toHeight);
    self.containerView.frame = CGRectMake(0, 0, size.width, size.height);
    self.scrollView.contentSize = CGSizeMake(MAX(self.frame.size.width - 16, self.containerView.bounds.size.width), MAX(self.frame.size.height, self.containerView.bounds.size.height));
    [self.scrollView scrollRectToVisible:self.bounds animated:NO];
    self.scrollView.alwaysBounceVertical = self.containerView.frame.size.height <= self.frame.size.height ? NO : YES;
    self.imageView.frame = self.containerView.bounds;
    [self scrollViewDidZoom:self.scrollView];
    self.scrollView.maximumZoomScale = MAX(MAX(image.size.width/(self.bounds.size.width), image.size.height / self.bounds.size.height), 3.f);
}

/**
 *  图片的单击事件
 */
- (void)_handleSingleTap {
    if ([self.delegate respondsToSelector:@selector(photoBrowserCellImageClick:indexPath:)]) {
        [self.delegate photoBrowserCellImageClick:self indexPath:self.indexPath];
    }
}

/**
 *  图片的双击事件
 *
 *  @param doubleTap 单击手势
 */
- (void)_handleDoubleTap:(UITapGestureRecognizer *)doubleTap {
    
    if (self.scrollView.zoomScale > 1.0f) {
        [self.scrollView setZoomScale:1.0 animated:YES];
    }else {
        CGPoint touchPoint = [doubleTap locationInView:self.imageView];
        CGFloat newZoomScale = self.scrollView.maximumZoomScale;
        CGFloat xsize = self.frame.size.width / newZoomScale;
        CGFloat ysize = self.frame.size.height / newZoomScale;
        [self.scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}


#pragma mark - UIScrollViewDelegate

/**
 *  要缩放的视图
 *  @return 返回要缩放的视图
 */
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.containerView;
}

/**
 *  用户缩放图片的时候调用此方法
*/
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    CGFloat offsetX = (scrollView.frame.size.width > scrollView.contentSize.width) ? (scrollView.frame.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.frame.size.height > scrollView.contentSize.height) ? (scrollView.frame.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.containerView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

#pragma mark - Getters
/**
 *  scrollview
 */
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width - STPhotoPadding, self.bounds.size.height)];
        _scrollView.bouncesZoom = YES;
        _scrollView.maximumZoomScale = 3.0f;
        _scrollView.minimumZoomScale = 1.0f;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delaysContentTouches = NO;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.alwaysBounceVertical = NO;
        
    }
    return _scrollView;
}

/**
 *  懒加载容器view
 *
 */
- (UIView *)containerView {
    
    if (!_containerView) {
        
        _containerView = [[UIView alloc] initWithFrame:self.bounds];
        _containerView.clipsToBounds = YES;
    }
    return _containerView;
}

/**
 *  懒加载imageview
 *
 */
- (UIImageView *)imageView {
    if (!_imageView) {
        
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}


#pragma mark - Class Methods
/**
 *  调整到指定尺寸
 *
 *  @param originSize 原始尺寸
 *  @param targetSize 目标尺寸
 *
 *  @return 返回等比例调整好的尺寸
 */
+ (CGSize)adjustOriginSize:(CGSize)originSize
              toTargetSize:(CGSize)targetSize {
    
    CGSize resultSize = CGSizeMake(originSize.width, originSize.height);
    
    /** 计算图片的比例 */
    CGFloat widthPercent = (originSize.width ) / (targetSize.width);
    CGFloat heightPercent = (originSize.height ) / targetSize.height;
    if (widthPercent <= 1.0f && heightPercent <= 1.0f) {
        resultSize = CGSizeMake(originSize.width, originSize.height);
    } else if (widthPercent > 1.0f && heightPercent < 1.0f) {
        
        resultSize = CGSizeMake(targetSize.width, (originSize.height * targetSize.width) / originSize.width);
    }else if (widthPercent <= 1.0f && heightPercent > 1.0f) {
        
        resultSize = CGSizeMake((targetSize.height * originSize.width) / originSize.height, targetSize.height);
    }else {
        if (widthPercent > heightPercent) {
            resultSize = CGSizeMake(targetSize.width, (originSize.height * targetSize.width) / originSize.width);
        }else {
            resultSize = CGSizeMake((targetSize.height * originSize.width) / originSize.height, targetSize.height);
        }
    }
    return resultSize;
}


@end
