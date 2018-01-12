//
//  JCCollectionViewTagFlowLayout.h
//  JCTagListView
//
//  Created by 李京城 on 15/7/3.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCCollectionViewTagFlowLayout : UICollectionViewFlowLayout
@property(nonatomic,copy)UIFont *font;                          //添加默认字体大小，用于计算长度
- (CGFloat)calculateContentHeight:(NSArray *)tags;
+ (CGFloat)calculateContentHeight:(NSArray *)tags;
@end
