//
//  ChangeBlock.h
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

@interface ChangeBlock : NSObject
-(NSUInteger)changeBlockShape:(UIImageView**)imageView andBlockMode:(NSUInteger)BlockMode;
@end
