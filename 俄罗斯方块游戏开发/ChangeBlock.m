//
//  ChangeBlock.m
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

//change block class
#import "ChangeBlock.h"
#import "BlockMode.h"
@implementation ChangeBlock
-(NSUInteger)changeBlockShape:(UIImageView**)imageView andBlockMode:(NSUInteger)BlockMode
{
    NSUInteger  tempBlockMode=0;
    if(BLOCK_MODE_0==BlockMode)
    {
        CGRect   rect=imageView[0].frame;
        for (NSUInteger i=1; i<4; i++)
        {
            imageView[i].frame=CGRectMake(rect.origin.x, i*20+rect.origin.y, rect.size.width, rect.size.height);
        }
        tempBlockMode=1;
    }
    else if(BLOCK_MODE_1==BlockMode)
    {
        CGRect   rect=imageView[0].frame;
        if(rect.origin.x>120)
        {
            rect.origin.x=120;
            imageView[0].frame=CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
        }
        for (NSUInteger i=1; i<4; i++)
        {
            imageView[i].frame=CGRectMake(rect.origin.x+i*20, rect.origin.y, rect.size.width, rect.size.height);
        }
        tempBlockMode=0;
    }
    else if(BLOCK_MODE_2==BlockMode)
    {
        CGRect   rect=imageView[0].frame;
        if(rect.origin.x<40)
        {
            rect.origin.x=40;
            imageView[0].frame=CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
            imageView[1].frame=CGRectMake(rect.origin.x, rect.origin.y+20, rect.size.width, rect.size.height);
        }
        for (NSUInteger i=2; i<4; i++)
        {
            imageView[i].frame=CGRectMake(rect.origin.x-(i-1)*20, rect.origin.y+20, rect.size.width, rect.size.height);
        }
        tempBlockMode=3;
    }
    else if(BLOCK_MODE_3==BlockMode)
    {
        CGRect   rect=imageView[0].frame;
        if (rect.origin.x>160) {
            rect.origin.x=160;
            imageView[0].frame=CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
        }
        for (NSUInteger i=1; i<4; i++)
        {
            imageView[i].frame=CGRectMake(rect.origin.x+20, rect.origin.y+(i-1)*20, rect.size.width, rect.size.height);
        }
        tempBlockMode=4;
    }
    else if(BLOCK_MODE_4==BlockMode)
    {
        CGRect   rect=imageView[0].frame;
        if(rect.origin.x>140)
        {
            rect.origin.x=140;
            imageView[0].frame=CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
        }
        imageView[1].frame=CGRectMake(rect.origin.x+20, rect.origin.y, rect.size.width, rect.size.height);
        imageView[2].frame=CGRectMake(rect.origin.x+40, rect.origin.y, rect.size.width, rect.size.height);
        imageView[3].frame=CGRectMake(rect.origin.x, rect.origin.y+20, rect.size.width, rect.size.height);
        tempBlockMode=5;
    }
    else if(BLOCK_MODE_5==BlockMode)
    {
        CGRect   rect=imageView[0].frame;
        for (NSUInteger i=1; i<4; i++)
        {
                if(3==i)
                imageView[i].frame=CGRectMake(rect.origin.x+20, rect.origin.y+40, rect.size.width, rect.size.height);
                else
                imageView[i].frame=CGRectMake(rect.origin.x, rect.origin.y+i*20, rect.size.width, rect.size.height);
        }
        tempBlockMode=2;
    }
    else if(BLOCK_MODE_6==BlockMode)
    {
        CGRect   rect=imageView[0].frame;
        if(rect.origin.x>140)
        {
            rect.origin.x=140;
            imageView[0].frame=CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
        }
        for (NSUInteger i=1; i<4; i++)
        {
            if(3==i)
                imageView[i].frame=CGRectMake(rect.origin.x+40, rect.origin.y+20, rect.size.width, rect.size.height);
            else
                imageView[i].frame=CGRectMake(rect.origin.x+i*20, rect.origin.y, rect.size.width, rect.size.height);
        }
        tempBlockMode=7;
    }
    else if(BLOCK_MODE_7==BlockMode)
    {
        CGRect   rect=imageView[0].frame;
        if(rect.origin.x<20)
        {
            rect.origin.x=20;
            imageView[0].frame=CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
        }
        for (NSUInteger i=1; i<4; i++)
        {
            if(1==i)
                imageView[i].frame=CGRectMake(rect.origin.x-20, rect.origin.y, rect.size.width, rect.size.height);
            else
                imageView[i].frame=CGRectMake(rect.origin.x-20, rect.origin.y+(i-1)*20, rect.size.width, rect.size.height);
        }
        tempBlockMode=8;
    }
    else if(BLOCK_MODE_8==BlockMode)
    {
        CGRect   rect=imageView[0].frame;
        if(rect.origin.x>140)
        {
            rect.origin.x=140;
            imageView[0].frame=CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
        }
        for (NSUInteger i=1; i<4; i++)
        {
            if(1==i)
                imageView[i].frame=CGRectMake(rect.origin.x, rect.origin.y+20, rect.size.width, rect.size.height);
            else
                imageView[i].frame=CGRectMake(rect.origin.x+(i-1)*20, rect.origin.y+20, rect.size.width, rect.size.height);
        }
        tempBlockMode=9;
    }
    else if(BLOCK_MODE_9==BlockMode)
    {
        CGRect   rect=imageView[0].frame;
        if(rect.origin.x<20)
        {
            rect.origin.x=20;
            imageView[0].frame=CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
            imageView[1].frame=CGRectMake(rect.origin.x, rect.origin.y+20, rect.size.width, rect.size.height);
        }
        imageView[2].frame=CGRectMake(rect.origin.x, rect.origin.y+40, rect.size.width, rect.size.height);
        imageView[3].frame=CGRectMake(rect.origin.x-20, rect.origin.y+40, rect.size.width, rect.size.height);
        tempBlockMode=6;
    }
    else if(BLOCK_MODE_10==BlockMode)
    {
        CGRect   rect=imageView[0].frame;
        if(rect.origin.x<20)
        {
            rect.origin.x=20;
            imageView[0].frame=CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
        }
        imageView[1].frame=CGRectMake(rect.origin.x+20, rect.origin.y, rect.size.width, rect.size.height);
        imageView[2].frame=CGRectMake(rect.origin.x-20, rect.origin.y+20, rect.size.width, rect.size.height);
        imageView[3].frame=CGRectMake(rect.origin.x, rect.origin.y+20, rect.size.width, rect.size.height);
        tempBlockMode=11;
    }
    else if(BLOCK_MODE_11==BlockMode)
    {
        CGRect   rect=imageView[0].frame;
        imageView[1].frame=CGRectMake(rect.origin.x, rect.origin.y+20, rect.size.width, rect.size.height);
        imageView[2].frame=CGRectMake(rect.origin.x+20, rect.origin.y+20, rect.size.width, rect.size.height);
        imageView[3].frame=CGRectMake(rect.origin.x+20, rect.origin.y+40, rect.size.width, rect.size.height);
        tempBlockMode=10;
    }
    else if(BLOCK_MODE_13==BlockMode)
    {
        CGRect   rect=imageView[0].frame;
        imageView[3].frame=CGRectMake(rect.origin.x, rect.origin.y+40, rect.size.width, rect.size.height);
        tempBlockMode=14;
    }
    else if(BLOCK_MODE_14==BlockMode)
    {
        CGRect   rect=imageView[0].frame;
        if(rect.origin.x>140)
        {
            rect.origin.x=140;
            imageView[0].frame=CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
        }
        imageView[1].frame=CGRectMake(rect.origin.x+20, rect.origin.y, rect.size.width, rect.size.height);
        imageView[2].frame=CGRectMake(rect.origin.x+40, rect.origin.y, rect.size.width, rect.size.height);
        imageView[3].frame=CGRectMake(rect.origin.x+20, rect.origin.y+20, rect.size.width, rect.size.height);
        tempBlockMode=15;
    }
    else if(BLOCK_MODE_15==BlockMode)
    {
        CGRect   rect=imageView[0].frame;
        imageView[1].frame=CGRectMake(rect.origin.x, rect.origin.y+20, rect.size.width, rect.size.height);
        imageView[2].frame=CGRectMake(rect.origin.x+20, rect.origin.y+20, rect.size.width, rect.size.height);
        imageView[3].frame=CGRectMake(rect.origin.x, rect.origin.y+40, rect.size.width, rect.size.height);
        tempBlockMode=16;
    }
    else if(BLOCK_MODE_16==BlockMode)
    {
        CGRect   rect=imageView[0].frame;
        if(rect.origin.x<20)
        {
            rect.origin.x=20;
            imageView[0].frame=CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
        }
        imageView[1].frame=CGRectMake(rect.origin.x-20, rect.origin.y+20, rect.size.width, rect.size.height);
        imageView[2].frame=CGRectMake(rect.origin.x, rect.origin.y+20, rect.size.width, rect.size.height);
        imageView[3].frame=CGRectMake(rect.origin.x+20, rect.origin.y+20, rect.size.width, rect.size.height);
        tempBlockMode=13;
    }
    return   tempBlockMode;
}
@end
