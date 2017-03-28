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

#import "SYPhotoCell.h"
#import "SYPhotoitem.h"
#import "SYPhotoLibraryTool.h"

@interface SYPhotoCell()
/**图片*/
@property(nonatomic,strong)UIImageView *imageview;
@end

@implementation SYPhotoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _imageview = [[UIImageView alloc] init];
        _imageview.contentMode = UIViewContentModeScaleAspectFill;
        _imageview.clipsToBounds = YES;
        _imageview.userInteractionEnabled = YES;
        [self.contentView addSubview:_imageview];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [_imageview addGestureRecognizer:tap];
        
        _selectBtn = [[UIButton alloc] init];
        [_selectBtn setImage:[UIImage imageNamed:@"ico_photo_thumb_uncheck.png"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"ico_photo_thumb_check.png"] forState:UIControlStateSelected];
        [_selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchDown];
        [self.contentView addSubview:_selectBtn];
    }
    return self;
}


/**
 *  设置界面数据
 *
 *  @param photoItem 照片模型
 */
- (void)setPhotoItem:(SYPhotoItem *)photoItem
{
    _photoItem  = photoItem;
    if (photoItem.image) {
        self.imageview.image = photoItem.image;
    }else {
        if (photoItem.asset != nil){
           [self performSelectorInBackground:@selector(loadImage) withObject:nil];
        }
    }
    if (photoItem.isSelected) {
        self.selectBtn.selected = YES;
    }else{
        self.selectBtn.selected = NO;
    }
}

/**
 *  加载图片
 */
- (void)loadImage
{
    [[SYPhotoLibraryTool sharedInstance] getThumbnailWithAsset:self.photoItem.asset size:CGSizeMake(80, 80) completionBlock:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageview.image = image;
            self.photoItem.image = image;
        });
    }];
}


#pragma mark event 
/**
 *  图片单击事件
 *
 *  @param tap 单击手势
 */
- (void)tap:(UITapGestureRecognizer*)tap
{
    //打开图片浏览器
    if ([self.delegate respondsToSelector:@selector(photoCellCoverDidSelected:currentIndex:)]) {
        [self.delegate photoCellCoverDidSelected:self currentIndex:self.indexPath.row];
    }
}

/**
 *  选择按钮点击
 *
 *  @param btn 选中的按钮
 */
- (void)selectBtnClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.photoItem.isSelected = YES;
        if ([self.delegate respondsToSelector:@selector(photoCellDidSelected:)]) {
            [self.delegate photoCellDidSelected:self];
        }
    }else{
        self.photoItem.isSelected = NO;
        if ([self.delegate respondsToSelector:@selector(photoCellCancleSelected:)]) {
            [self.delegate photoCellCancleSelected:self];
        }
    }
}


#pragma mark layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    _imageview.frame = self.bounds;
    CGFloat btnwh = 40;
    CGFloat btnx =  self.bounds.size.width - btnwh;
    _selectBtn.frame = CGRectMake(btnx, 0, btnwh, btnwh);
}

@end
