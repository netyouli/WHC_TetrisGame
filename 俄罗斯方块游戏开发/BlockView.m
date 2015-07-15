//
//  BlockView.m
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

#import "BlockView.h"
#import "ChangeBlock.h"
#import "BlockMode.h"

@implementation BlockView
@synthesize moveBlock=_moveBlock;
@synthesize changeBlock=_changeBlock;
@synthesize gramRank=_gramRank;
@synthesize gramTime=_gramTime;
@synthesize gramGrade=_gramGrade;
-(void)dealloc
{
    NSUInteger  i=0;
    for (i=0; i<4; ) {
        [currentImageView[i] release];
        [showNextBlock[i] release];
    }
    for (i=0; i<blockSum; i++)
    {
        [imageView[i] release];
    }
    [_gramTime  release];
    [_gramRank  release];
    [_gramGrade release];
    [super  dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        blockViewHeight = frame.size.height - 40.0;
        KBlockSum = frame.size.height / 20;
        blockSum=0;
        blockPoint.x=80;
        blockPoint.y=0;
        showNextPoint.x=230;
        showNextPoint.y=0;
        image=[UIImage imageNamed:@"block"];
        isMove=YES;
        isBottom=YES;//标示创建
        isCreateShowNextBlock=NO;
        yBlock = blockViewHeight;
        self.moveBlock=[[MoveBlock alloc]init];
        self.moveBlock.del=self;//设置代理
        self.changeBlock=[[ChangeBlock alloc]init];
        isStopMove=YES;//表示不是移动状态
        threadTimer=1.0f;
        rankDwonTimer = threadTimer;
        quickMoveMark=NO;
        srand((unsigned)time(0));
        timerBlock=arc4random() % 17 ;
        releaseRowCount=0;
        showNextBlock[0]=nil;
        left=NO;
        [self  createGramInfoListView];
    }
    return self;
}
-(void)getTimeAndGradeWithRank
{
    //获取当前系统时间
    NSDate  *dataTime=[NSDate  date];
    //创建时间格式对象
    NSDateFormatter  *dateFormatter=[[NSDateFormatter  alloc]init];
    //指定时间格式
    [dateFormatter  setDateFormat:@"hh:mm:ss  "];
    _gramTime.text=[NSString  stringWithFormat:@"%@",[dateFormatter   stringFromDate:dataTime]];
    [dateFormatter  release];
}
//创建游戏相关信息view
-(void)createGramInfoListView
{
    //创建基本的显示控件
    self.gramTime=[[UILabel  alloc]initWithFrame:CGRectMake(220, 100,100 ,50)];//显示时间
    _gramTime.backgroundColor=[UIColor  blackColor];
    _gramTime.textColor=[UIColor  blueColor];
    _gramTime.text=@"";
    self.gramRank=[[UILabel  alloc]initWithFrame:CGRectMake(220, 200,100 ,50)];//显示游戏等级
    _gramRank.backgroundColor=[UIColor  blackColor];
    _gramRank.textColor=[UIColor  blueColor];
    _gramRank.text=GRAM_RANK;
    self.gramGrade=[[UILabel  alloc]initWithFrame:CGRectMake(220, 300,100 ,50)];//显示游戏分数
    _gramGrade.backgroundColor=[UIColor  blackColor];
    _gramGrade.textColor=[UIColor  blueColor];
    _gramGrade.text=GRAM_GRADE;
    _gramGrade.text=[NSString  stringWithFormat:@"%@%lu",GRAM_GRADE,releaseRowCount*10];
    _gramRank.text=[NSString  stringWithFormat:@"%@%lu",GRAM_RANK,releaseRowCount/1000+1];
    gameRank = 1;
    [self  addSubview:_gramRank];
    [self  addSubview:_gramTime];
    [self  addSubview:_gramGrade];
    [_gramTime  release];
    [_gramRank  release];
    [_gramGrade  release];
    [self getTimeAndGradeWithRank];
        
}
-(UIImageView*)showUIImageViewtoX:(NSUInteger)x andy:(NSUInteger)y
{
    UIImageView *blockImageView=[[UIImageView  alloc]initWithImage:[UIImage imageNamed:@"block"]];
    blockImageView.frame=CGRectMake(x, y, 20.0, 20.0);
    return blockImageView;
}
-(UIImageView*)CreateUIImageViewtoX:(NSUInteger)x andy:(NSUInteger)y
{
    UIImageView *blockImageView=[[UIImageView  alloc]initWithImage:[UIImage imageNamed:@"block"]];
    blockImageView.frame=CGRectMake(x, y, 20.0, 20.0);
    //[self   addSubview:blockImageView];
    return blockImageView;
}
-(void)createBlockWay:(NSUInteger)blockWay
{
    if(KBlockSum == blockSum)
        return;
    if(blockWay<17)
    {
        isMove=YES;
        blockMode=blockWay;
    }
    switch (blockWay)
    {
        case BLOCK_MODE_0://创建一方式
        {
            for (int index=0; index<4; index++)
            {
                currentImageView[index]=[self  CreateUIImageViewtoX:blockPoint.x+index*20 andy:blockPoint.y];
                imageView[blockSum++]=currentImageView[index];
            }
        }
            break;
        case BLOCK_MODE_1://创建竖方式
        {
            for (int index=0; index<4; index++)
            {
                currentImageView[index]=[self  CreateUIImageViewtoX:blockPoint.x andy:blockPoint.y+index*20];
                imageView[blockSum++]=currentImageView[index];
            }
        }
            break;
        case BLOCK_MODE_2://创建L方式
        {
            for (int index=0; index<4; index++)
            {
                if(3==index)
                {
                    currentImageView[index]=[self  CreateUIImageViewtoX:blockPoint.x+20 andy:blockPoint.y+2*20];
                    imageView[blockSum++]=currentImageView[index];
                    break;
                }
                currentImageView[index]=[self  CreateUIImageViewtoX:blockPoint.x andy:blockPoint.y+index*20];
                 imageView[blockSum++]=currentImageView[index];
            }
        }
            break;
        case BLOCK_MODE_3:
        {
            currentImageView[0]=[self  CreateUIImageViewtoX:blockPoint.x andy:blockPoint.y];
            imageView[blockSum++]=currentImageView[0];
            currentImageView[1]=[self  CreateUIImageViewtoX:blockPoint.x andy:blockPoint.y+20];
            imageView[blockSum++]=currentImageView[1];
            currentImageView[2]=[self  CreateUIImageViewtoX:blockPoint.x-20 andy:blockPoint.y+20];
            imageView[blockSum++]=currentImageView[2];
            currentImageView[3]=[self  CreateUIImageViewtoX:blockPoint.x-40 andy:blockPoint.y+20];
            imageView[blockSum++]=currentImageView[3];
        }
            break;
        case BLOCK_MODE_4:
        {
            currentImageView[0]=[self  CreateUIImageViewtoX:blockPoint.x andy:blockPoint.y];
            imageView[blockSum++]=currentImageView[0];
            currentImageView[1]=[self  CreateUIImageViewtoX:blockPoint.x+20 andy:blockPoint.y];
            imageView[blockSum++]=currentImageView[1];
            currentImageView[2]=[self  CreateUIImageViewtoX:blockPoint.x+20 andy:blockPoint.y+20];
            imageView[blockSum++]=currentImageView[2];
            currentImageView[3]=[self  CreateUIImageViewtoX:blockPoint.x+20 andy:blockPoint.y+40];
            imageView[blockSum++]=currentImageView[3];
        }
            break;
        case BLOCK_MODE_5:
        {
            currentImageView[0]=[self  CreateUIImageViewtoX:blockPoint.x andy:blockPoint.y];
            imageView[blockSum++]=currentImageView[0];
            currentImageView[1]=[self  CreateUIImageViewtoX:blockPoint.x+20 andy:blockPoint.y];
            imageView[blockSum++]=currentImageView[1];
            currentImageView[2]=[self  CreateUIImageViewtoX:blockPoint.x+40 andy:blockPoint.y];
            imageView[blockSum++]=currentImageView[2];
            currentImageView[3]=[self  CreateUIImageViewtoX:blockPoint.x andy:blockPoint.y+20];
            imageView[blockSum++]=currentImageView[3];
        }
            break;
        case BLOCK_MODE_6://创建反L方式
        {
            for (int index=0; index<4; index++)
            {
                if(3==index)
                {
                    currentImageView[index]=[self  CreateUIImageViewtoX:blockPoint.x-20 andy:blockPoint.y+2*20];
                    imageView[blockSum++]=currentImageView[index];
                    break;
                }
                currentImageView[index]=[self  CreateUIImageViewtoX:blockPoint.x andy:blockPoint.y+index*20];
                imageView[blockSum++]=currentImageView[index];
            }
        }
            break;
        case BLOCK_MODE_7:
        {
            currentImageView[0]=[self  CreateUIImageViewtoX:blockPoint.x andy:blockPoint.y];
            imageView[blockSum++]=currentImageView[0];
            currentImageView[1]=[self  CreateUIImageViewtoX:blockPoint.x+20 andy:blockPoint.y];
            imageView[blockSum++]=currentImageView[1];
            currentImageView[2]=[self  CreateUIImageViewtoX:blockPoint.x+40 andy:blockPoint.y];
            imageView[blockSum++]=currentImageView[2];
            currentImageView[3]=[self  CreateUIImageViewtoX:blockPoint.x+40 andy:blockPoint.y+20];
            imageView[blockSum++]=currentImageView[3];
        }
            break;
        case BLOCK_MODE_8:
        {
            currentImageView[0]=[self  CreateUIImageViewtoX:blockPoint.x andy:blockPoint.y];
            imageView[blockSum++]=currentImageView[0];
            currentImageView[1]=[self  CreateUIImageViewtoX:blockPoint.x+20 andy:blockPoint.y];
            imageView[blockSum++]=currentImageView[1];
            currentImageView[2]=[self  CreateUIImageViewtoX:blockPoint.x andy:blockPoint.y+20];
            imageView[blockSum++]=currentImageView[2];
            currentImageView[3]=[self  CreateUIImageViewtoX:blockPoint.x andy:blockPoint.y+40];
            imageView[blockSum++]=currentImageView[3];
        }
            break;
        case BLOCK_MODE_9:
        {
            currentImageView[0]=[self  CreateUIImageViewtoX:blockPoint.x andy:blockPoint.y];
            imageView[blockSum++]=currentImageView[0];
            currentImageView[1]=[self  CreateUIImageViewtoX:blockPoint.x andy:blockPoint.y+20];
            imageView[blockSum++]=currentImageView[1];
            currentImageView[2]=[self  CreateUIImageViewtoX:blockPoint.x+20 andy:blockPoint.y+20];
            imageView[blockSum++]=currentImageView[2];
            currentImageView[3]=[self  CreateUIImageViewtoX:blockPoint.x+40 andy:blockPoint.y+20];
            imageView[blockSum++]=currentImageView[3];
        }
            break;
        case BLOCK_MODE_10://创建z方式
        {
            currentImageView[0]=[self  CreateUIImageViewtoX:blockPoint.x andy:blockPoint.y];
            imageView[blockSum++]=currentImageView[0];
            currentImageView[1]=[self  CreateUIImageViewtoX:blockPoint.x andy:blockPoint.y+20];
            imageView[blockSum++]=currentImageView[1];
            currentImageView[2]=[self  CreateUIImageViewtoX:blockPoint.x+20 andy:blockPoint.y+20];
            imageView[blockSum++]=currentImageView[2];
            currentImageView[3]=[self  CreateUIImageViewtoX:blockPoint.x+20 andy:blockPoint.y+40];
            imageView[blockSum++]=currentImageView[3];
        }
            break;
        case BLOCK_MODE_11:
        {
            currentImageView[0]=[self  CreateUIImageViewtoX:blockPoint.x andy:blockPoint.y];
            imageView[blockSum++]=currentImageView[0];
            currentImageView[1]=[self  CreateUIImageViewtoX:blockPoint.x+20 andy:blockPoint.y];
            imageView[blockSum++]=currentImageView[1];
            currentImageView[2]=[self  CreateUIImageViewtoX:blockPoint.x-20 andy:blockPoint.y+20];
            imageView[blockSum++]=currentImageView[2];
            currentImageView[3]=[self  CreateUIImageViewtoX:blockPoint.x andy:blockPoint.y+20];
            imageView[blockSum++]=currentImageView[3];
        }
            break;
        case BLOCK_MODE_12://创建田方式
        {
            currentImageView[0]=[self  CreateUIImageViewtoX:blockPoint.x andy:blockPoint.y];
            imageView[blockSum++]=currentImageView[0];
            currentImageView[1]=[self  CreateUIImageViewtoX:blockPoint.x+20 andy:blockPoint.y];
            imageView[blockSum++]=currentImageView[1];
            currentImageView[2]=[self  CreateUIImageViewtoX:blockPoint.x andy:blockPoint.y+20];
            imageView[blockSum++]=currentImageView[2];
            currentImageView[3]=[self  CreateUIImageViewtoX:blockPoint.x+20 andy:blockPoint.y+20];
            imageView[blockSum++]=currentImageView[3];
        }
            break;
        case BLOCK_MODE_13://创建土方式
        {
            currentImageView[0]=[self  CreateUIImageViewtoX:blockPoint.x andy:blockPoint.y];
            imageView[blockSum++]=currentImageView[0];
            currentImageView[1]=[self  CreateUIImageViewtoX:blockPoint.x-20 andy:blockPoint.y+20];
            imageView[blockSum++]=currentImageView[1];
            currentImageView[2]=[self  CreateUIImageViewtoX:blockPoint.x andy:blockPoint.y+20];
            imageView[blockSum++]=currentImageView[2];
            currentImageView[3]=[self  CreateUIImageViewtoX:blockPoint.x+20 andy:blockPoint.y+20];
            imageView[blockSum++]=currentImageView[3];
        }
            break;
        case BLOCK_MODE_14:
        {
            currentImageView[0]=[self  CreateUIImageViewtoX:blockPoint.x andy:blockPoint.y];
            imageView[blockSum++]=currentImageView[0];
            currentImageView[1]=[self  CreateUIImageViewtoX:blockPoint.x-20 andy:blockPoint.y+20];
            imageView[blockSum++]=currentImageView[1];
            currentImageView[2]=[self  CreateUIImageViewtoX:blockPoint.x andy:blockPoint.y+20];
            imageView[blockSum++]=currentImageView[2];
            currentImageView[3]=[self  CreateUIImageViewtoX:blockPoint.x andy:blockPoint.y+40];
            imageView[blockSum++]=currentImageView[3];
        }
            break;
        case BLOCK_MODE_15:
        {
            currentImageView[0]=[self  CreateUIImageViewtoX:blockPoint.x andy:blockPoint.y];
            imageView[blockSum++]=currentImageView[0];
            currentImageView[1]=[self  CreateUIImageViewtoX:blockPoint.x+20 andy:blockPoint.y];
            imageView[blockSum++]=currentImageView[1];
            currentImageView[2]=[self  CreateUIImageViewtoX:blockPoint.x+40 andy:blockPoint.y];
            imageView[blockSum++]=currentImageView[2];
            currentImageView[3]=[self  CreateUIImageViewtoX:blockPoint.x+20 andy:blockPoint.y+20];
            imageView[blockSum++]=currentImageView[3];
        }
            break;
        case BLOCK_MODE_16:
        {
            currentImageView[0]=[self  CreateUIImageViewtoX:blockPoint.x andy:blockPoint.y];
            imageView[blockSum++]=currentImageView[0];
            currentImageView[1]=[self  CreateUIImageViewtoX:blockPoint.x andy:blockPoint.y+20];
            imageView[blockSum++]=currentImageView[1];
            currentImageView[2]=[self  CreateUIImageViewtoX:blockPoint.x+20 andy:blockPoint.y+20];
            imageView[blockSum++]=currentImageView[2];
            currentImageView[3]=[self  CreateUIImageViewtoX:blockPoint.x andy:blockPoint.y+40];
            imageView[blockSum++]=currentImageView[3];
        }
            break;
        default:
            break;
    }
    for (NSUInteger  index=0; index<4; index++)
    {
        [self  addSubview:currentImageView[index]];
    }
}
-(void)showNextBlockMode
{
    if(nil!=showNextBlock[0] || nil!=showNextBlock[3])
    {
        //这里进行清空
        for (NSUInteger l=0; l<4; l++)
        {
            showNextBlock[l].hidden=YES;
            [showNextBlock[l]  release];
            showNextBlock[l]=nil;
        }
    }
    switch (timerBlock)
    {
    case BLOCK_MODE_0://创建一方式
        {
            for (int index=0; index<4; index++)
            {
                showNextBlock[index]=[self  showUIImageViewtoX:showNextPoint.x+index*20 andy:showNextPoint.y];
            }
        }
        break;
    case BLOCK_MODE_1://创建竖方式
        {
            for (int index=0; index<4; index++)
            {
                showNextBlock[index]=[self  showUIImageViewtoX:showNextPoint.x andy:showNextPoint.y+index*20];
            }
        }
        break;
    case BLOCK_MODE_2://创建L方式
        {
            for (int index=0; index<4; index++)
            {
                if(3==index)
                {
                    showNextBlock[index]=[self  showUIImageViewtoX:showNextPoint.x+20 andy:showNextPoint.y+2*20];
                }
                showNextBlock[index]=[self  showUIImageViewtoX:showNextPoint.x andy:showNextPoint.y+index*20];
            }
        }
        break;
    case BLOCK_MODE_3:
        {
            showNextBlock[0]=[self  showUIImageViewtoX:showNextPoint.x andy:showNextPoint.y];
            showNextBlock[1]=[self  showUIImageViewtoX:showNextPoint.x andy:showNextPoint.y+20];
            showNextBlock[2]=[self  showUIImageViewtoX:showNextPoint.x-20 andy:showNextPoint.y+20];
            showNextBlock[3]=[self  showUIImageViewtoX:showNextPoint.x-40 andy:showNextPoint.y+20];
        }
        break;
    case BLOCK_MODE_4:
        {
            showNextBlock[0]=[self  showUIImageViewtoX:showNextPoint.x andy:showNextPoint.y];
            showNextBlock[1]=[self  showUIImageViewtoX:showNextPoint.x+20 andy:showNextPoint.y];
            showNextBlock[2]=[self  showUIImageViewtoX:showNextPoint.x+20 andy:showNextPoint.y+20];
            showNextBlock[3]=[self  showUIImageViewtoX:showNextPoint.x+20 andy:showNextPoint.y+40];
        }
        break;
    case BLOCK_MODE_5:
        {
            showNextBlock[0]=[self  showUIImageViewtoX:showNextPoint.x andy:showNextPoint.y];
            showNextBlock[1]=[self  showUIImageViewtoX:showNextPoint.x+20 andy:showNextPoint.y];
            showNextBlock[2]=[self  showUIImageViewtoX:showNextPoint.x+40 andy:showNextPoint.y];
            showNextBlock[3]=[self  showUIImageViewtoX:showNextPoint.x andy:showNextPoint.y+20];
        }
        break;
    case BLOCK_MODE_6://创建反L方式
        {
            for (int index=0; index<4; index++)
            {
                if(3==index)
                {
                    showNextBlock[index]=[self  showUIImageViewtoX:showNextPoint.x-20 andy:showNextPoint.y+2*20];
                }
                showNextBlock[index]=[self  showUIImageViewtoX:showNextPoint.x andy:showNextPoint.y+index*20];
            }
        }
        break;
    case BLOCK_MODE_7:
        {
            showNextBlock[0]=[self  showUIImageViewtoX:showNextPoint.x andy:showNextPoint.y];
            showNextBlock[1]=[self  showUIImageViewtoX:showNextPoint.x+20 andy:showNextPoint.y];
            showNextBlock[2]=[self  showUIImageViewtoX:showNextPoint.x+40 andy:showNextPoint.y];
            showNextBlock[3]=[self  showUIImageViewtoX:showNextPoint.x+40 andy:showNextPoint.y+20];
        }
        break;
    case BLOCK_MODE_8:
        {
            showNextBlock[0]=[self  showUIImageViewtoX:showNextPoint.x andy:showNextPoint.y];
            showNextBlock[1]=[self  showUIImageViewtoX:showNextPoint.x+20 andy:showNextPoint.y];
            showNextBlock[2]=[self  showUIImageViewtoX:showNextPoint.x andy:showNextPoint.y+20];
            showNextBlock[3]=[self  showUIImageViewtoX:showNextPoint.x andy:showNextPoint.y+40];
        }
        break;
    case BLOCK_MODE_9:
        {
            showNextBlock[0]=[self  showUIImageViewtoX:showNextPoint.x andy:showNextPoint.y];
            showNextBlock[1]=[self  showUIImageViewtoX:showNextPoint.x andy:showNextPoint.y+20];
            showNextBlock[2]=[self  showUIImageViewtoX:showNextPoint.x+20 andy:showNextPoint.y+20];
            showNextBlock[3]=[self  showUIImageViewtoX:showNextPoint.x+40 andy:showNextPoint.y+20];
        }
        break;
    case BLOCK_MODE_10://创建z方式
        {
            showNextBlock[0]=[self  showUIImageViewtoX:showNextPoint.x andy:showNextPoint.y];
            showNextBlock[1]=[self  showUIImageViewtoX:showNextPoint.x andy:showNextPoint.y+20];
            showNextBlock[2]=[self  showUIImageViewtoX:showNextPoint.x+20 andy:showNextPoint.y+20];
            showNextBlock[3]=[self  showUIImageViewtoX:showNextPoint.x+20 andy:showNextPoint.y+40];
        }
        break;
    case BLOCK_MODE_11:
        {
            showNextBlock[0]=[self  showUIImageViewtoX:showNextPoint.x andy:showNextPoint.y];
            showNextBlock[1]=[self  showUIImageViewtoX:showNextPoint.x+20 andy:showNextPoint.y];
            showNextBlock[2]=[self  showUIImageViewtoX:showNextPoint.x-20 andy:showNextPoint.y+20];
            showNextBlock[3]=[self  showUIImageViewtoX:showNextPoint.x andy:showNextPoint.y+20];
        }
        break;
    case BLOCK_MODE_12://创建田方式
        {
            showNextBlock[0]=[self  showUIImageViewtoX:showNextPoint.x andy:showNextPoint.y];
            showNextBlock[1]=[self  showUIImageViewtoX:showNextPoint.x+20 andy:showNextPoint.y];
            showNextBlock[2]=[self  showUIImageViewtoX:showNextPoint.x andy:showNextPoint.y+20];
            showNextBlock[3]=[self  showUIImageViewtoX:showNextPoint.x+20 andy:showNextPoint.y+20];
        }
        break;
    case BLOCK_MODE_13://创建土方式
        {
            showNextBlock[0]=[self  showUIImageViewtoX:showNextPoint.x andy:showNextPoint.y];
            showNextBlock[1]=[self  showUIImageViewtoX:showNextPoint.x-20 andy:showNextPoint.y+20];
            showNextBlock[2]=[self  showUIImageViewtoX:showNextPoint.x andy:showNextPoint.y+20];
            showNextBlock[3]=[self  showUIImageViewtoX:showNextPoint.x+20 andy:showNextPoint.y+20];
        }
        break;
    case BLOCK_MODE_14:
        {
            showNextBlock[0]=[self  showUIImageViewtoX:showNextPoint.x andy:showNextPoint.y];
            showNextBlock[1]=[self  showUIImageViewtoX:showNextPoint.x-20 andy:showNextPoint.y+20];
            showNextBlock[2]=[self  showUIImageViewtoX:showNextPoint.x andy:showNextPoint.y+20];
            showNextBlock[3]=[self  showUIImageViewtoX:showNextPoint.x andy:showNextPoint.y+40];
        }
        break;
    case BLOCK_MODE_15:
        {
            showNextBlock[0]=[self  showUIImageViewtoX:showNextPoint.x andy:showNextPoint.y];
            showNextBlock[1]=[self  showUIImageViewtoX:showNextPoint.x+20 andy:showNextPoint.y];
            showNextBlock[2]=[self  showUIImageViewtoX:showNextPoint.x+40 andy:showNextPoint.y];
            showNextBlock[3]=[self  showUIImageViewtoX:showNextPoint.x+20 andy:showNextPoint.y+20];
        }
        break;
    case BLOCK_MODE_16:
        {
            showNextBlock[0]=[self  showUIImageViewtoX:showNextPoint.x andy:showNextPoint.y];
            showNextBlock[1]=[self  showUIImageViewtoX:showNextPoint.x andy:showNextPoint.y+20];
            showNextBlock[2]=[self  showUIImageViewtoX:showNextPoint.x+20 andy:showNextPoint.y+20];
            showNextBlock[3]=[self  showUIImageViewtoX:showNextPoint.x andy:showNextPoint.y+40];
        }
        break;
    default:
        break;
    }
    for (NSUInteger  index=0; index<4; index++)
    {
        [self  addSubview:showNextBlock[index]];
    }
}
//UIAlertView 的代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSUInteger  i=0;
    for (i=0; i<4;i++) {
        [currentImageView[i] removeFromSuperview];
        [currentImageView[i] release];
        currentImageView[i]=nil;
        [showNextBlock[i] removeFromSuperview];
        [showNextBlock[i] release];
        showNextBlock[i]=nil;
    }
    NSArray * arrView = self.subviews;
    for (UIImageView * iv in arrView) {
        if([iv isKindOfClass:[UIImageView class]]){
            [iv removeFromSuperview];
            iv = nil;
        }
    }
    for(i = 0; i < blockSum;i++){
        imageView[i]=nil;
    }
    _gramRank.text=@"等级:0";
    _gramGrade.text= @"分数:0";
    blockSum=0;
    //表示重新开始游戏
    isStopMove=YES;
    isMove=YES;
    isBottom=YES;//标示创建
}
//检测游戏是否结束
-(BOOL)checkGramOver
{
    BOOL  mark=NO;
    for (NSUInteger i=0; i<blockSum; i++)
    {
        if(imageView[i].frame.origin.y<=0)
        {
            NSLog(@"游戏结束");
            mark=YES;
            break;
        }
    }
    if(mark)
    {//表明游戏已经结束
        isStopMove=NO;//停止当前游戏
        UIAlertView  *msg=[[UIAlertView  alloc]initWithTitle:@"提示" message:@"游戏结束" delegate:self cancelButtonTitle:@"重新开始" otherButtonTitles:nil, nil];
        [msg  show];
    }
    return mark;
    
}
//自动下降block线程
-(void)mainThreadMoveBlock
{
    [self getTimeAndGradeWithRank];
//    NSLog(@"timer=%d",timer);
    if(isBottom)
    {//如果到了block到了底部就创建新的
        if(YES==quickMoveMark)
        {
            threadTimer = rankDwonTimer;
            quickMoveMark=NO;
        }
        if(blockSum>4)
        {
            if([self checkGramOver])
                //如果游戏结束就直接返回
            return;
        }
        [self createBlockWay:timerBlock];
        srand((unsigned)time(0));
        timerBlock=arc4random() % 17 ;
        [self showNextBlockMode];
        isBottom=NO;
    }
    else
    {//否则移动当前的block
        [_moveBlock  setMoveParam:&isMove and:&isBottom];
        [_moveBlock  moveBlock:currentImageView andYblock:yBlock];
        
    }
}
-(void)moveBlcokThread
{
    while (YES)
    {
        //让当前线程挂机0.5s
        [NSThread   sleepForTimeInterval:threadTimer];
        if(isStopMove==NO)
            continue;
        //调用主线程里面的函数
        [self   performSelectorOnMainThread:@selector(mainThreadMoveBlock) withObject:nil waitUntilDone:YES];
    }
}
//创建自动下降block线程
-(void)createMoveBlockThread
{
    //创建一个线程并且马上执行
    [NSThread  detachNewThreadSelector:@selector(moveBlcokThread) toTarget:self withObject:nil];
}
-(CGPoint)getCurrentImageViewPoint
{
    CGPoint   point=currentImageView[0].frame.origin;
    return point;
}
//检测旁边是否有其他block挡着
-(BOOL)checkNerX:(CGFloat)x andY:(CGFloat)y
{
    BOOL  mark=NO;
    
    for (NSUInteger  i=0;i< blockSum-4; i++)
    {
        if (y<imageView[i].frame.origin.y)
            mark=YES;
        if(YES==left && y==imageView[i].frame.origin.y)
        {
            if(imageView[i].frame.origin.x+20<x)
                mark=YES;
            else
                return NO;
        }
        else if(NO==left && y==imageView[i].frame.origin.y)
        {
            if((imageView[i].frame.origin.x-20)>x )
                mark=YES;
            else
                return NO;
        }
    }
    return mark;
}
//检测当前是否能够变换
-(BOOL)changeX:(CGFloat)x andy:(CGFloat)y andConst:(CGFloat)con isBool:(BOOL)r
{
    BOOL  mark=NO;
    for (NSUInteger  i=0; i<(blockSum-4); i++)
    {
        if(imageView[i].frame.origin.y==y )
        {
            if(YES==r)
            {//如果是向右变换
                if((x+con)>=imageView[i].frame.origin.x)
                {
                    return NO;
                }
                else
                    mark=YES;
            }
            else if(NO==r)
            {//如果是向左变换
                if((x-con)<=imageView[i].frame.origin.x)
                {
                    return  NO;
                }
                else
                    mark=YES;
            }
        }
        else
        {
            mark=YES;
        }
    }
    return mark;
}
//检测当前是否满足变换条件
-(BOOL)checkCurrentIsChange
{
    BOOL  mark=NO;
    switch (blockMode) {
        case BLOCK_MODE_0:
            mark=[self  changeScanY:currentImageView[3].frame.origin.y+60];
            break;
        case BLOCK_MODE_1:
            mark=[self  changeX:currentImageView[0].frame.origin.x andy:currentImageView[0].frame.origin.y-60 andConst:60 isBool:YES];
            break;
        case BLOCK_MODE_2:
            mark=[self  changeX:currentImageView[3].frame.origin.x andy:currentImageView[3].frame.origin.y-20 andConst:60 isBool:NO];
            break;
        case BLOCK_MODE_3:
            mark=[self  changeScanY:currentImageView[3].frame.origin.y+20];
                if (!mark)
                    return NO;
            mark=[self  changeX:currentImageView[1].frame.origin.x andy:currentImageView[1].frame.origin.y-20 andConst:20 isBool:YES];
            break;
        case BLOCK_MODE_4:
             mark=[self  changeX:currentImageView[2].frame.origin.x andy:currentImageView[2].frame.origin.y-20 andConst:20 isBool:YES];
            break;
        case BLOCK_MODE_5:
            mark=YES;
            break;
        case BLOCK_MODE_6:
             mark=[self  changeX:currentImageView[2].frame.origin.x andy:currentImageView[2].frame.origin.y-40 andConst:40 isBool:YES];
            if (!mark)
                return NO;
            mark=[self  changeX:currentImageView[3].frame.origin.x andy:currentImageView[3].frame.origin.y-20 andConst:60 isBool:YES];
            break;
        case BLOCK_MODE_7:
            mark=[self  changeScanY:currentImageView[3].frame.origin.y+20];
            if (!mark) 
                return NO;
            mark=[self  changeX:currentImageView[1].frame.origin.x andy:currentImageView[1].frame.origin.y andConst:20 isBool:NO];
            if (!mark)
                return NO;
            mark=[self  changeX:currentImageView[2].frame.origin.x andy:currentImageView[2].frame.origin.y-20 andConst:60 isBool:NO];
            break;
        case BLOCK_MODE_8:
            mark=[self  changeX:currentImageView[3].frame.origin.x andy:currentImageView[3].frame.origin.y-20 andConst:60 isBool:YES];
            break;
        case BLOCK_MODE_9:
            mark=[self  changeX:currentImageView[3].frame.origin.x andy:currentImageView[3].frame.origin.y+20 andConst:60 isBool:NO];
            break;
        case BLOCK_MODE_10:
            mark=[self  changeX:currentImageView[2].frame.origin.x andy:currentImageView[2].frame.origin.y andConst:40 isBool:NO];
            break;
        case BLOCK_MODE_11:
            mark=[self  changeScanY:currentImageView[2].frame.origin.y+20];
        case BLOCK_MODE_12:
            mark=YES;
            break;
        case BLOCK_MODE_13:
            mark=[self  changeScanY:currentImageView[2].frame.origin.y+60];
            break;
        case BLOCK_MODE_14:
            mark=[self  changeX:currentImageView[2].frame.origin.x andy:currentImageView[2].frame.origin.y-20 andConst:40 isBool:YES];
            break;
        case BLOCK_MODE_15:
            mark=[self  changeScanY:currentImageView[3].frame.origin.y+60];
            break;
        case BLOCK_MODE_16:
            mark=[self  changeX:currentImageView[1].frame.origin.x andy:currentImageView[1].frame.origin.y andConst:20 isBool:NO];
            break;
        default:
            break;
    }
    return mark;
}
-(BOOL)changeScanY:(CGFloat)y
{
    BOOL  mark=NO;
    for(NSUInteger i=0;i<blockSum-4;i++)
    {
        if(y>=imageView[i].frame.origin.y)
        {
            return NO;
            NSLog(@"ssss");
        }
        else
            mark=YES;
    }
    return mark;
}
//手指开始触摸
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(1==event.allTouches.count)
    {
        if(YES==isStopMove)
            isStopMove=NO;
        else
            isStopMove=YES;
        //如果当前只有一个手指触摸
        NSArray  *allTouches=[event.allTouches  allObjects];
        //获取点的坐标
        onePoint=[[allTouches  objectAtIndex:0] locationInView:self];
    }
    UITouch  *touche=(UITouch*)[event.allTouches  anyObject];
    NSUInteger   tapCount=[touche  tapCount];
    if(2==tapCount)
    {//双击
        for (NSUInteger i=0; i<4; i++)
        {
            if(currentImageView[i].frame.origin.y>=blockViewHeight)
                //如果到了底部就不支持变换
                return;
        }
        if(blockSum>4)
        {
            if(NO==[self  checkCurrentIsChange])
                return;
        }
        if(BLOCK_MODE_12 !=blockMode)
        blockMode=[_changeBlock  changeBlockShape:currentImageView andBlockMode:blockMode];
    }
}
//手指开始移动
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSInteger     blockDistance;
    NSInteger     yDistance;
    // 如果direction为no就为左移动，为yes为右移动
    if(1==event.allTouches.count)
    {
        isStopMove=YES;
        //如果只有一个只手在移动
        NSArray   *allTouches=[event.allTouches  allObjects];
        CGPoint  twoPoint=[[allTouches  objectAtIndex:0]locationInView:self];
        //计算两个点得x轴坐标距离和y轴的距离
        blockDistance= twoPoint.x-onePoint.x;
        yDistance= twoPoint.y-onePoint.y;
        if(blockSum>4)
        {//如果当前屏幕上得block不为空时
            if(blockDistance > 0)
                left=NO;
            else
            {
                left=YES;
            }
            for (NSUInteger  i=0; i<4; i++)
                 if(NO==[self  checkNerX:currentImageView[i].frame.origin.x andY:currentImageView[i].frame.origin.y])
                     return;
        }
        if(yDistance>50)
        {
            threadTimer=0.05;
            quickMoveMark=YES;
            return;
        }
        int  i = (int)blockDistance / 20;
        if((i >= 1 || i <= -1) && i != 0 ){
             [_moveBlock  TouchesMoveBlock:currentImageView distance:i * 20 withBlockMode:blockMode];
            onePoint = twoPoint;
        }
    }
}
//触摸结束
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

//检测是否能够堆叠
-(NSUInteger)checkYDirectionBlockCount:(NSUInteger*)ind
{
    NSUInteger     count;
    BOOL           isHave=NO;
    if(blockSum<=4)
    {
        *ind=3;
        return blockViewHeight;
    }
    NSUInteger   min= blockViewHeight,temp;
    for (NSUInteger index=0; index<blockSum-4; index++)
    {
        for (NSUInteger  i=0; i<4; i++)
        {
            if(currentImageView[i].frame.origin.x==imageView[index].frame.origin.x)
            {
                temp=imageView[index].frame.origin.y-currentImageView[i].frame.origin.y;
                if(20>=temp)
                {
                    isMove=NO;
                    isBottom=YES;
                    return 0;
                }
                if(temp <= min)
                {
                    min=temp;
                    count=imageView[index].frame.origin.y-40;
                    *ind=i;
                    isHave=YES;
                }
            }
        }
    }
    if(NO== isHave)
    {
        count = blockViewHeight;
        *ind=3;
    }
    return count;
}
//消除行
-(void)releaseBlockLine
{
    NSUInteger   count=0;
    NSUInteger   index[10]={0};
    CGRect       rect[10];
    UIImageView  *tempView[270]={nil};
    NSUInteger   tempIndex=0;
    for (NSInteger j = self.frame.size.height - 20; j>=0;j-=20 )
    {
        for (NSUInteger  i=0; i<blockSum; i++)
        {
            if(imageView[i].frame.origin.y==j)
            {
                index[count]=i;
                rect[count]=imageView[i].frame;
                count++;
            }
        }
        if(10==count)
        {
            releaseRowCount++;
            _gramGrade.text=[NSString  stringWithFormat:@"%@%u",GRAM_GRADE,releaseRowCount*10];
            _gramRank.text=[NSString  stringWithFormat:@"%@%u",GRAM_RANK,releaseRowCount/1000 +1];
            if((NSInteger)releaseRowCount/1000 >= gameRank){
                gameRank++;
                rankDwonTimer -= 0.1;
                if(rankDwonTimer < 0.1){
                    rankDwonTimer = 0.1;
                }
                threadTimer = rankDwonTimer;
            }
            //进行消行处理
            NSLog(@"满足消除行的条件");
            for (NSUInteger  m=0; m<10; m++)
            {
                imageView[index[m]].hidden=YES;
                [imageView[index[m]]  release];
                imageView[index[m]]=nil;
            }
            //把上面的往下移动
            for (NSUInteger k=0; k<10; k++)
            {
                for (NSUInteger n=0; n<blockSum; n++)
                {
                    if(nil!=imageView[n] && imageView[n].frame.origin.y<j)
                    {
                        if (rect[k].origin.x==imageView[n].frame.origin.x)
                        {
                            imageView[n].frame=CGRectMake(imageView[n].frame.origin.x, imageView[n].frame.origin.y+20, imageView[n].frame.size.width, imageView[n].frame.size.height);
                        }
                    }
                }
            }
            //对图片进行移位填充刚release掉得
            for(NSUInteger  l=0;l<blockSum;l++)
            {
                if(nil!=imageView[l])
                {
                    tempView[tempIndex++]=imageView[l];
                    imageView[l]=nil;
                }
            }
            for (NSUInteger  o=0; o<tempIndex; o++)
            {
                imageView[o]=tempView[o];
                tempView[o]=nil;
            }
            j+=20;
            count=0;
            tempIndex=0;
            blockSum-=10;
        }
        else
        {
            count=0;
        }
    }
}
@end

