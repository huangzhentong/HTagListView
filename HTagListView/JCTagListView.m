//
//  JCTagListView.m
//  JCTagListView
//
//  Created by 李京城 on 15/7/3.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import "JCTagListView.h"

@interface JCTagListView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, copy) JCTagListViewBlock selectedBlock;
@property (nonatomic, copy) NSIndexPath *currentPath;

@end

@implementation JCTagListView

static NSString * const reuseIdentifier = @"tagListViewItemId";

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
}

- (void)setup {
    _selectedTags = [NSMutableArray array];
    _tags = [NSMutableArray array];
    
    _tagStrokeColor = [UIColor lightGrayColor];
    _tagSelectStrokeColor = _tagStrokeColor;
    _tagBackgroundColor = [UIColor clearColor];
    _tagTextColor = [UIColor darkGrayColor];
    _tagSelectedTextColor = [UIColor darkGrayColor];
    _tagSelectedBackgroundColor = [UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1];
    _tagTextFont = [UIFont systemFontOfSize:14.0];
    _multipleSelectTags = YES;
    _tagCornerRadius = 10.0f;
    
    [self addSubview:self.collectionView];
}


-(void)setMultipleSelectTags:(BOOL)multipleSelectTags
{
    if (multipleSelectTags == NO) {
        if (self.selectedTags.count>1) {
            id object = self.selectedTags.firstObject;
            [self.selectedTags removeAllObjects];
            [self.selectedTags addObject:object];
        }
    }
    _multipleSelectTags = multipleSelectTags;
}
-(void)setSelectedTags:(NSMutableArray *)selectedTags
{
    _selectedTags = [NSMutableArray new];
    if (_multipleSelectTags == NO) {
        if (selectedTags.count >= 1) {
            [_selectedTags addObject:selectedTags.firstObject];
        }
    }
    else
    {
        [_selectedTags addObjectsFromArray:selectedTags];
    }
}

- (void)setCompletionBlockWithSelected:(JCTagListViewBlock)completionBlock {
    self.selectedBlock = completionBlock;
}

#pragma mark - UICollectionViewDelegate | UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tags.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    JCCollectionViewTagFlowLayout *layout = (JCCollectionViewTagFlowLayout *)collectionView.collectionViewLayout;
    CGSize maxSize = CGSizeMake(collectionView.frame.size.width - layout.sectionInset.left - layout.sectionInset.right - 20, layout.itemSize.height);
    
    CGRect frame = [self.tags[indexPath.item] boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.tagTextFont} context:nil];
    
    return CGSizeMake(frame.size.width + 20.0f, frame.size.height + 10.0f);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JCTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = self.tagBackgroundColor;
    cell.layer.borderColor = self.tagStrokeColor.CGColor;
    cell.layer.cornerRadius = self.tagCornerRadius;
    cell.titleLabel.text = self.tags[indexPath.item];
    cell.titleLabel.textColor = self.tagTextColor;
    cell.titleLabel.font = self.tagTextFont;
    
    if ([self.selectedTags containsObject:self.tags[indexPath.item]]) {
        if(self.selectedTags.count ==1)
        {
            self.currentPath = indexPath;
        }
        cell.backgroundColor = self.tagSelectedBackgroundColor;
        cell.titleLabel.textColor = self.tagSelectedTextColor;
        cell.layer.borderColor = self.tagSelectStrokeColor.CGColor;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.canSelectTags) {
        JCTagCell *cell = (JCTagCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        if (_multipleSelectTags == NO) {
            [self.selectedTags removeAllObjects];
            if (_currentPath == nil) {
                cell.backgroundColor = self.tagSelectedBackgroundColor;
                cell.titleLabel.textColor = self.tagSelectedTextColor;
                
                [self.selectedTags addObject:self.tags[indexPath.item]];
                
                _currentPath  = indexPath;
            }
            else
            {
                if (_currentPath.row != indexPath.row) {
                    JCTagCell *lastCell =  [collectionView cellForItemAtIndexPath:_currentPath];
                    lastCell.backgroundColor = self.tagBackgroundColor;
                    lastCell.titleLabel.textColor = self.tagTextColor;
                    lastCell.layer.borderColor = self.tagStrokeColor.CGColor;
                    
                    cell.backgroundColor = self.tagSelectedBackgroundColor;
                    cell.titleLabel.textColor = self.tagSelectedTextColor;
                    cell.layer.borderColor = self.tagSelectStrokeColor.CGColor;
                    [self.selectedTags addObject:self.tags[indexPath.item]];
                    _currentPath  = indexPath;
                }
                else
                {
                    cell.backgroundColor = self.tagBackgroundColor;
                    cell.titleLabel.textColor = self.tagTextColor;
                    cell.layer.borderColor = self.tagSelectStrokeColor.CGColor;
                    [self.selectedTags removeAllObjects];
                    _currentPath = nil;
                }
                
                
            }
            
        }
        else
        {
            
            if ([self.selectedTags containsObject:self.tags[indexPath.item]]) {
                cell.backgroundColor = self.tagBackgroundColor;
                cell.titleLabel.textColor = self.tagTextColor;
                cell.layer.borderColor = self.tagStrokeColor.CGColor;
                [self.selectedTags removeObject:self.tags[indexPath.item]];
            }
            else {
                cell.backgroundColor = self.tagSelectedBackgroundColor;
                cell.titleLabel.textColor = self.tagSelectedTextColor;
                cell.layer.borderColor = self.tagSelectStrokeColor.CGColor;
                [self.selectedTags addObject:self.tags[indexPath.item]];
            }
        }
    }
    
    if (self.selectedBlock) {
        self.selectedBlock(indexPath.item);
    }
}

#pragma mark - setter/getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        JCCollectionViewTagFlowLayout *layout = [[JCCollectionViewTagFlowLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[JCTagCell class] forCellWithReuseIdentifier:reuseIdentifier];
    }
    
    return _collectionView;
}

@end
