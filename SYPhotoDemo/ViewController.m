//
//  ViewController.m
//  markDownDemo
//
//  Created by 舒少勇 on 2017/3/20.
//  Copyright © 2017年 舒少勇. All rights reserved.
//

#import "ViewController.h"
#import "SYPhotoConst.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
}

- (IBAction)imgBtn {
    
    SYPhotoGroupViewController *vc = [[SYPhotoGroupViewController alloc] init];
    vc.videoEnabled = NO;
    vc.didFinishcompletionBlock = ^(NSArray *items)
    {
        NSLog(@"选择的图片：%@",items);
    };
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}


- (IBAction)videoBtn {
    
    SYPhotoGroupViewController *vc = [[SYPhotoGroupViewController alloc] init];
    vc.videoEnabled = YES;
    vc.didFinishcompletionBlock = ^(NSArray *items)
    {
        NSLog(@"选择的视频：%@",items);
    };
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
