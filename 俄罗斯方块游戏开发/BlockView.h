//
//  BlockView.h
//  俄罗斯方块游戏开发
//
//  Created by 吴海超 on 13-7-27.
//  Copyright (c) 2013年 apple. All rights reserved.
//

/*
 *  qq:712641411
 *  qq群:460122071
 *  gitHub:https://github.com/netyouli
 *  csdn:http://blog.csdn.net/windwhc/article/category/3117381
 */

#import <UIKit/UIKit.h>
#import "MoveBlock.h"
@class ChangeBlock;
@class ReleaseBlockLine;

@interface BlockView : UIView<Delegate,UIAlertViewDelegate>
{
    CGFloat        rankDwonTimer; //等级下掉时间
    NSInteger      gameRank;      //游戏级别
    NSInteger      KBlockSum;
    NSInteger      blockViewHeight;
    BOOL           isMove;
    BOOL           isBottom;
    NSUInteger     blockMode;     //标示创建哪种block
    UIImageView    *imageView[270];
    NSUInteger     blockSum;
    CGPoint        blockPoint;
    CGPoint        showNextPoint;  //预创建block坐标位置
    UIImage        *image;
    UIImageView    *currentImageView[4];
    UIImageView    *showNextBlock[4];
    CGPoint        onePoint;
    NSUInteger     yBlock;
    BOOL           isStopMove;
    BOOL           isCreateShowNextBlock;//标示是否创建预block
    CGFloat        threadTimer;
    BOOL           quickMoveMark;
    NSUInteger     timerBlock;   //随机产生的block类型
    NSUInteger     releaseRowCount;//记录消除了多少行
    BOOL  left;
}
@property  (nonatomic,retain)ChangeBlock *changeBlock;
@property  (nonatomic,retain)MoveBlock   *moveBlock;
@property  (nonatomic,retain)UILabel   *gramTime;
@property  (nonatomic,retain)UILabel   *gramGrade;
@property  (nonatomic,retain)UILabel   *gramRank;
-(void)getTimeAndGradeWithRank;
-(void)createMoveBlockThread;
-(void)showNextBlockMode;
-(void)createGramInfoListView;
-(UIImageView*)showUIImageViewtoX:(NSUInteger)x andy:(NSUInteger)y;
-(UIImageView*)CreateUIImageViewtoX:(NSUInteger)x andy:(NSUInteger)y;
-(BOOL)checkNerX:(CGFloat)x andY:(CGFloat)y;
-(BOOL)changeScanY:(CGFloat)y;
-(BOOL)checkCurrentIsChange;
-(BOOL)checkGramOver;
-(BOOL)changeX:(CGFloat)x andy:(CGFloat)y andConst:(CGFloat)con isBool:(BOOL)r;
@end
