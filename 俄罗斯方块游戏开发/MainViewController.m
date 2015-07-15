//
//  MainViewController.m
//  俄罗斯方块游戏开发
//
//  Created by 吴海超 on 13-7-23.
//  Copyright (c) 2013年 apple. All rights reserved.
//

/*
 *  qq:712641411
 *  qq群:460122071
 *  gitHub:https://github.com/netyouli
 *  csdn:http://blog.csdn.net/windwhc/article/category/3117381
 */

#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BlockView.h"

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize blockView=_blockView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

//初始化程员变量
-(void)initMemberVarible
{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self  initMemberVarible];
    self.view.backgroundColor=[UIColor  blackColor];
    NSLog(@"    [UIScreen mainScreen].bounds.size.width = %f",    [UIScreen mainScreen].bounds.size.height);
    NSInteger height = (NSInteger)[UIScreen mainScreen].bounds.size.height - 20.0;
    NSInteger remainder = height % 20;   //40,420
    BlockView * view=[[BlockView  alloc]initWithFrame:CGRectMake(10.0, 20.0, 200.0,  height - remainder)];
    view.backgroundColor=[UIColor  blackColor];
    //设置边框的颜色
    view.layer.borderColor = [[UIColor blueColor] CGColor];
    view.layer.borderWidth=2.0f;
    [self.view  addSubview:view];
    self.blockView=view;
    [view release];
    //创建自动下降block线程
    [_blockView  createMoveBlockThread];
    	// Do any additional setup after loading the view.
}
-(void)dealloc
{
 
    [super  dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
