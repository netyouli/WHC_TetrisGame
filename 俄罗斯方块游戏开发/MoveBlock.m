//
//  MoveBlock.m
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

//atou move block class
#import "MoveBlock.h"
#import "BlockMode.h"
@implementation MoveBlock
@synthesize del=_del;
-(id)init
{
    self=[super  init];
    if(self)
    {
        bottomMoveCapacity=20;
        return self;
    }
    else
        return nil;
}
//设置移动参数
-(void)setMoveParam:(BOOL*)Move and:(BOOL*)Bottom
{
    isMove=Move;
    isBottom=Bottom;
}
//准备移动imageView
-(void)moveBlock:(UIImageView **)imageView andYblock:(NSUInteger)yBlock
{
    if(NO ==(*isMove))
        return ;
    //检测下面是否有其他的block
    yBlock=[_del  checkYDirectionBlockCount:&ind];
    if(yBlock==0)
        return;
    for (NSUInteger  index=0; index<4; index++)
    {
        *isBottom=[self  move:imageView[index]and:index yCount:yBlock];
        if(*isBottom)
        {//在这里移动未移动的图片
            if(0==ind)
            {
                for (NSUInteger  i=1; i<4; i++)
                {
                    CGRect  rect=imageView[i].frame;
                    imageView[i].frame=CGRectMake(rect.origin.x,rect.origin.y+bottomMoveCapacity , rect.size.width, rect.size.height);
                }
               
            }
            else if(1==ind)
            {
                for (NSUInteger  i=2; i<4; i++)
                {
                    CGRect  rect=imageView[i].frame;
                    imageView[i].frame=CGRectMake(rect.origin.x,rect.origin.y+bottomMoveCapacity , rect.size.width, rect.size.height);
                }
            }
            else if(2==ind)
            {
                for (NSUInteger  i=3; i<4; i++)
                {
                    CGRect  rect=imageView[i].frame;
                    imageView[i].frame=CGRectMake(rect.origin.x,rect.origin.y+bottomMoveCapacity , rect.size.width, rect.size.height);
                }
            }
            //这里进行检测当前是否能够消除行
            [_del releaseBlockLine];
            break;
        }
    }
    
}
//开始移动ImageView
-(BOOL)move:(UIImageView *)blockImageView and:(NSUInteger)indexMark yCount:(NSUInteger)yBlock
{
    BOOL  bBottom=NO;
    CGRect  rect=blockImageView.frame;
    blockImageView.frame=CGRectMake(rect.origin.x,rect.origin.y+bottomMoveCapacity , rect.size.width, rect.size.height);
    if(ind==indexMark && yBlock==rect.origin.y)
    {
        *isMove=NO;
        bBottom=YES;
    }
//    NSLog(@"Point.x=%f   Point.y=%f",rect.origin.x,rect.origin.y);
    return bBottom;
}
//当触摸进行左右移动
-(void)TouchesMoveBlock:(UIImageView **)imageView distance:(NSInteger)blockDistance withBlockMode:(NSUInteger)BlockMode
{
    BOOL  direction=NO;//表示向左还是向右移动
    if(blockDistance<0)
    {
        direction=NO;//标示左移动
    }
    else
    {
        direction=YES;//右移动
    }
    blockDistance = abs(blockDistance);
    for (NSUInteger  index=0; index<4; index++)
    {
        CGRect  tempRect=imageView[index].frame;
        if(NO== direction)
        {//向左移动
            BOOL  moveMark=NO;
            for (NSUInteger  k=0; k<4; k++)
            {
                if((imageView[k].frame.origin.x-blockDistance)<0)
                    moveMark=YES;//说明移到了外面
            }
             //检测是否移到了外面
            if(YES== moveMark)
            {
                //如果移动到了外面，则移动到靠边
                switch (BlockMode)
                {
                    case BLOCK_MODE_0:
                    {
                        for (NSUInteger  i=0; i<4; i++)
                        {
                            CGRect  imageRect=imageView[i].frame;
                            imageView[i].frame=CGRectMake(i*20, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                        }
                    }
                        break;
                    case BLOCK_MODE_1:
                    {
                        for (NSUInteger  i=0; i<4; i++)
                        {
                            CGRect  imageRect=imageView[i].frame;
                            imageView[i].frame=CGRectMake(0, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                        }
                    }
                        break;
                    case BLOCK_MODE_2:
                    {
                        for (NSUInteger  i=0; i<4; i++)
                        {
                            CGRect  imageRect=imageView[i].frame;
                            if(3==i)
                            imageView[i].frame=CGRectMake(20, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                            else
                            imageView[i].frame=CGRectMake(0, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                        }
                    }
                        break;
                    case BLOCK_MODE_3:
                    {
                        for (NSInteger  i=0; i<4; i++)
                        {
                            CGRect  imageRect=imageView[i].frame;
                            if(0==i)
                                imageView[i].frame=CGRectMake(40, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                            else
                                imageView[i].frame=CGRectMake(60-(i*20), imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                        }
                    }
                        break;
                    case BLOCK_MODE_4:
                    {
                        for (NSInteger  i=0; i<4; i++)
                        {
                            CGRect  imageRect=imageView[i].frame;
                            if(0==i)
                                imageView[i].frame=CGRectMake(0, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                            else
                                imageView[i].frame=CGRectMake(20, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                        }
                    }
                        break;
                    case BLOCK_MODE_5:
                    {
                        for (NSInteger  i=0; i<4; i++)
                        {
                            CGRect  imageRect=imageView[i].frame;
                            if(0==i || 3==i)
                                imageView[i].frame=CGRectMake(0, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                            else
                                imageView[i].frame=CGRectMake(i*20, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                        }
                    }
                        break;
                    case BLOCK_MODE_6:
                    {
                        for (NSInteger  i=0; i<4; i++)
                        {
                            CGRect  imageRect=imageView[i].frame;
                            if(3==i)
                                imageView[i].frame=CGRectMake(0, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                            else
                                imageView[i].frame=CGRectMake(20, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                        }
                    }
                        break;
                    case BLOCK_MODE_7:
                    {
                        for (NSInteger  i=0; i<4; i++)
                        {
                            CGRect  imageRect=imageView[i].frame;
                            if(3==i)
                                imageView[i].frame=CGRectMake((i-1)*20, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                            else
                                imageView[i].frame=CGRectMake(i*20, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                        }
                    }
                        break;
                    case BLOCK_MODE_8:
                    {
                        for (NSInteger  i=0; i<4; i++)
                        {
                            CGRect  imageRect=imageView[i].frame;
                            if(0==i)
                                imageView[i].frame=CGRectMake(20, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                            else
                                imageView[i].frame=CGRectMake(0, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                        }
                    }
                        break;
                    case BLOCK_MODE_9:
                    {
                        for (NSInteger  i=0; i<4; i++)
                        {
                            CGRect  imageRect=imageView[i].frame;
                            if(0==i || 1==i)
                                imageView[i].frame=CGRectMake(0, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                            else
                                imageView[i].frame=CGRectMake((i-1)*20, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                        }
                    }
                        break;
                    case BLOCK_MODE_10:
                    {
                        for (NSInteger  i=0; i<4; i++)
                        {
                            CGRect  imageRect=imageView[i].frame;
                            if(0==i || 1==i)
                                imageView[i].frame=CGRectMake(0, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                            else
                                imageView[i].frame=CGRectMake(20, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                        }
                    }
                        break;
                    case BLOCK_MODE_11:
                    {
                        for (NSInteger  i=0; i<4; i++)
                        {
                            CGRect  imageRect=imageView[i].frame;
                            if(0==i || 1==i)
                                imageView[i].frame=CGRectMake(20*(i+1), imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                            else
                                imageView[i].frame=CGRectMake(20*(i-2), imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                        }
                    }
                        break;
                    case BLOCK_MODE_12:
                    {
                        for (NSInteger  i=0; i<4; i++)
                        {
                            CGRect  imageRect=imageView[i].frame;
                            if(0==i || 1==i)
                                imageView[i].frame=CGRectMake(20*i, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                            else
                                imageView[i].frame=CGRectMake(20*(i-2), imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                        }
                    }
                        break;
                    case BLOCK_MODE_13:
                    {
                        for (NSInteger  i=0; i<4; i++)
                        {
                            CGRect  imageRect=imageView[i].frame;
                            if(0==i)
                                imageView[i].frame=CGRectMake(20, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                            else
                                imageView[i].frame=CGRectMake(20*(i-1), imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                        }
                    }
                        break;
                    case BLOCK_MODE_14:
                    {
                        for (NSInteger  i=0; i<4; i++)
                        {
                            CGRect  imageRect=imageView[i].frame;
                            if(1==i)
                                imageView[i].frame=CGRectMake(0, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                            else
                                imageView[i].frame=CGRectMake(20, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                        }
                    }
                        break;
                    case BLOCK_MODE_15:
                    {
                        for (NSInteger  i=0; i<4; i++)
                        {
                            CGRect  imageRect=imageView[i].frame;
                            if(3==i)
                                imageView[i].frame=CGRectMake(20, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                            else
                                imageView[i].frame=CGRectMake(20*i, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                        }
                    }
                        break;
                    case BLOCK_MODE_16:
                    {
                        for (NSInteger  i=0; i<4; i++)
                        {
                            CGRect  imageRect=imageView[i].frame;
                            if(3==i || 0==i || 1==i)
                                imageView[i].frame=CGRectMake(0, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                            else
                                imageView[i].frame=CGRectMake(20, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                        }
                    }
                        break;
                    default:
                        break;
                }
                break;
            }
            else
            {
                imageView[index].frame=CGRectMake(tempRect.origin.x-blockDistance, tempRect.origin.y,tempRect.size.width, tempRect.size.height);
            }
        }
        else
        {//向右移动
            BOOL   moveMark=NO;
            //检测是否移到了外面
            for (NSUInteger  k=0; k<4; k++)
            {
                if((imageView[k].frame.origin.x+blockDistance)>180)
                    moveMark=YES;
            }
            if(YES== moveMark)
            {
                //如果移动到了外面，则移动到靠边
                switch (BlockMode)
                {
                    case BLOCK_MODE_0:
                    {
                        for (NSUInteger  i=0; i<4; i++)
                        {
                            CGRect  imageRect=imageView[i].frame;
                            imageView[i].frame=CGRectMake(120+(i*20), imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                        }
                    }
                        break;
                    case BLOCK_MODE_1:
                    {
                        for (NSUInteger  i=0; i<4; i++)
                        {
                            CGRect  imageRect=imageView[i].frame;
                            imageView[i].frame=CGRectMake(180, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                        }
                    }
                        break;
                    case BLOCK_MODE_2:
                    {
                        for (NSUInteger  i=0; i<4; i++)
                        {
                            CGRect  imageRect=imageView[i].frame;
                            if(3==i)
                                imageView[i].frame=CGRectMake(180, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                            else
                                imageView[i].frame=CGRectMake(160, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                        }
                    }
                        break;
                    case BLOCK_MODE_3:
                    {
                        
                        for (NSInteger  i=0; i<4; i++)
                        {
                            CGRect  imageRect=imageView[i].frame;
                            if(0==i)
                                imageView[i].frame=CGRectMake(180, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                            else
                                imageView[i].frame=CGRectMake(200-(i*20), imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                        }
                    }
                        break;
                    case BLOCK_MODE_4:
                    {
                        for (NSInteger  i=0; i<4; i++)
                        {
                            CGRect  imageRect=imageView[i].frame;
                            if(0==i)
                                imageView[i].frame=CGRectMake(160, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                            else
                                imageView[i].frame=CGRectMake(180, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                        }
                    }
                        break;
                    case BLOCK_MODE_5:
                    {
                        for (NSInteger  i=0; i<4; i++)
                        {
                            CGRect  imageRect=imageView[i].frame;
                            if(0==i || 3==i)
                                imageView[i].frame=CGRectMake(140, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                            else
                                imageView[i].frame=CGRectMake(140+(i*20), imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                        }
                    }
                        break;
                    case BLOCK_MODE_6:
                    {
                        for (NSInteger  i=0; i<4; i++)
                        {
                            CGRect  imageRect=imageView[i].frame;
                            if(3==i)
                                imageView[i].frame=CGRectMake(160, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                            else
                                imageView[i].frame=CGRectMake(180, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                        }
                    }
                        break;
                    case BLOCK_MODE_7:
                    {
                        for (NSInteger  i=0; i<4; i++)
                        {
                            CGRect  imageRect=imageView[i].frame;
                            if(3==i)
                                imageView[i].frame=CGRectMake(180, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                            else
                                imageView[i].frame=CGRectMake(140+(i*20), imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                        }
                    }
                        break;
                    case BLOCK_MODE_8:
                    {
                        for (NSInteger  i=0; i<4; i++)
                        {
                            CGRect  imageRect=imageView[i].frame;
                            if(0==i)
                                imageView[i].frame=CGRectMake(180, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                            else
                                imageView[i].frame=CGRectMake(160, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                        }
                    }
                        break;
                    case BLOCK_MODE_9:
                    {
                        for (NSInteger  i=0; i<4; i++)
                        {
                            CGRect  imageRect=imageView[i].frame;
                            if(0==i || 1==i)
                                imageView[i].frame=CGRectMake(140, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                            else
                                imageView[i].frame=CGRectMake(140+((i-1)*20), imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                        }
                    }
                        break;
                    case BLOCK_MODE_10:
                    {
                        for (NSInteger  i=0; i<4; i++)
                        {
                            CGRect  imageRect=imageView[i].frame;
                            if(0==i || 1==i)
                                imageView[i].frame=CGRectMake(160, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                            else
                                imageView[i].frame=CGRectMake(180, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                        }
                    }
                        break;
                    case BLOCK_MODE_11:
                    {
                        for (NSInteger  i=0; i<4; i++)
                        {
                            CGRect  imageRect=imageView[i].frame;
                            if(0==i || 1==i)
                                imageView[i].frame=CGRectMake(180-(20*i), imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                            else
                                imageView[i].frame=CGRectMake(140+(20*(i-2)), imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                        }
                    }
                        break;
                    case BLOCK_MODE_12:
                    {
                        for (NSInteger  i=0; i<4; i++)
                        {
                            CGRect  imageRect=imageView[i].frame;
                            if(0==i || 1==i)
                                imageView[i].frame=CGRectMake(160+(20*i), imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                            else
                                imageView[i].frame=CGRectMake(160+(20*(i-2)), imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                        }
                    }
                        break;
                    case BLOCK_MODE_13:
                    {
                        for (NSInteger  i=0; i<4; i++)
                        {
                            CGRect  imageRect=imageView[i].frame;
                            if(0==i)
                                imageView[i].frame=CGRectMake(160, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                            else
                                imageView[i].frame=CGRectMake(140+(20*(i-1)), imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                        }
                    }
                        break;
                    case BLOCK_MODE_14:
                    {
                        for (NSInteger  i=0; i<4; i++)
                        {
                            CGRect  imageRect=imageView[i].frame;
                            if(1==i)
                                imageView[i].frame=CGRectMake(160, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                            else
                                imageView[i].frame=CGRectMake(180, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                        }
                    }
                        break;
                    case BLOCK_MODE_15:
                    {
                        for (NSInteger  i=0; i<4; i++)
                        {
                            CGRect  imageRect=imageView[i].frame;
                            if(3==i)
                                imageView[i].frame=CGRectMake(160, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                            else
                                imageView[i].frame=CGRectMake(140+(20*i), imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                        }
                    }
                        break;
                    case BLOCK_MODE_16:
                    {
                        for (NSInteger  i=0; i<4; i++)
                        {
                            CGRect  imageRect=imageView[i].frame;
                            if(3==i || 0==i || 1==i)
                                imageView[i].frame=CGRectMake(160, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                            else
                                imageView[i].frame=CGRectMake(180, imageRect.origin.y,imageRect.size.width, imageRect.size.height);
                        }
                    }
                        break;
                    default:
                        break;
                }
                break;
           }
            else
            {
                imageView[index].frame=CGRectMake(tempRect.origin.x+blockDistance, tempRect.origin.y,tempRect.size.width, tempRect.size.height);
            }
        }
   
    }
}

@end
