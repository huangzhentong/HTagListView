//
//  JCTagListView.h
//  JCTagListView
//
//  Created by 李京城 on 15/7/3.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import <UIKit/UIKit.h>

// for Carthage
#import "JCTagCell.h"
#import "JCCollectionViewTagFlowLayout.h"

typedef void (^JCTagListViewBlock)(NSIndexPath *index);

IB_DESIGNABLE
@interface JCTagListView : UIView

@property (nonatomic, strong) IBInspectable UIColor *tagStrokeColor; // default: lightGrayColor
@property (nonatomic, strong) IBInspectable UIColor *tagSelectStrokeColor; // default: lightGrayColor
@property (nonatomic, strong) IBInspectable UIColor *tagTextColor; // default: darkGrayColor
@property (nonatomic, strong) IBInspectable UIColor *tagSelectedTextColor; // default: darkGrayColor
@property (nonatomic, strong) IBInspectable UIColor *tagBackgroundColor; // default: clearColor
@property (nonatomic, strong) IBInspectable UIColor *tagSelectedBackgroundColor; // default: rgb(217,217,217)

@property (nonatomic, assign) IBInspectable BOOL canSelectTags; // default: NO
@property (nonatomic, assign) IBInspectable BOOL multipleSelectTags; // default: YES 是否多选
@property (nonatomic, assign) IBInspectable CGFloat tagCornerRadius; // default: 10

@property (nonatomic, strong) UIFont *tagTextFont; // default: [UIFont systemFontOfSize:14.0f]

@property (nonatomic, strong) NSMutableArray *tags;
@property (nonatomic, strong) NSMutableArray *selectedTags;
@property (nonatomic) UIEdgeInsets sectionInsets;                     //左右间距
@property (nonatomic) CGFloat minItemWidth;                           //最小宽度
@property (nonatomic) CGFloat minItemHeigth;                          //最小宽度
@property (nonatomic) CGFloat maxItemCount;                          //最大个数
@property (nonatomic) CGFloat minimumInteritemSpacing;
@property (nonatomic, strong) UICollectionView *collectionView;

- (void)setCompletionBlockWithSelected:(JCTagListViewBlock)completionBlock;

@end
