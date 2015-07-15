//
//  MoveBlock.h
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

#import <Foundation/Foundation.h>
@protocol Delegate<NSObject>
@required
-(NSUInteger)checkYDirectionBlockCount:(NSUInteger*)ind;
-(void)releaseBlockLine;
@end
@interface MoveBlock : NSObject
{
    BOOL  *isMove;
    BOOL  *isBottom;
    NSUInteger  ind;
    NSUInteger  bottomMoveCapacity;//向下移动的计量
}
@property (assign)id <Delegate> del;//设置一个协议对象
-(void)moveBlock:(UIImageView **)imageView andYblock:(NSUInteger)yBlock;
-(BOOL)move:(UIImageView *)blockImageView and:(NSUInteger)indexMark yCount:(NSUInteger)yBlock;
-(void)setMoveParam:(BOOL*)Move and:(BOOL*)Bottom;
-(void)TouchesMoveBlock:(UIImageView **)imageView distance:(NSInteger)blockDistance withBlockMode:(NSUInteger)BlockMode;
@end
