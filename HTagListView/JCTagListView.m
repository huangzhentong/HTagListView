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
-(void)setSectionInsets:(UIEdgeInsets)sectionInsets
{
    JCCollectionViewTagFlowLayout *layout = (JCCollectionViewTagFlowLayout *)self.collectionView.collectionViewLayout;
    if (layout) {
        layout.sectionInset = sectionInsets;
    }
    _sectionInsets  = sectionInsets;
}
-(void)setMinimumInteritemSpacing:(CGFloat)minimumInteritemSpacing
{
    JCCollectionViewTagFlowLayout *layout = (JCCollectionViewTagFlowLayout *)self.collectionView.collectionViewLayout;
    if (layout) {
        layout.minimumInteritemSpacing = minimumInteritemSpacing;
    }
    _minimumInteritemSpacing = minimumInteritemSpacing;
}
-(CGFloat)minItemWidth
{
    if(self.maxItemCount <= 0)
    {
        return 0;
    }
    else
    {
        CGFloat width = CGRectGetWidth(self.frame);
        
        width = (width - self.sectionInsets.left - self.sectionInsets.right - (self.maxItemCount-1)*self.minimumInteritemSpacing)/self.maxItemCount;
        return width;
        
    }
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

-(id)getTagsOjbectWithIndexPath:(NSIndexPath*)indexPath
{
    NSString *text = nil;
    if ([[self.tags firstObject] isKindOfClass:[NSArray class]]) {
        text = self.tags[indexPath.section][indexPath.item];
    }
    else
    {
        text = self.tags[indexPath.item];
    }
    return text;
}


#pragma mark - UICollectionViewDelegate | UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if ([[self.tags firstObject] isKindOfClass:[NSArray class]]) {
        
        return [self.tags count];
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([[self.tags firstObject] isKindOfClass:[NSArray class]]) {
        
        return [self.tags[section] count];
    }
    return self.tags.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    JCCollectionViewTagFlowLayout *layout = (JCCollectionViewTagFlowLayout *)collectionView.collectionViewLayout;
    CGSize maxSize = CGSizeMake(collectionView.frame.size.width - layout.sectionInset.left - layout.sectionInset.right - 20, layout.itemSize.height);
    
    NSString *text = [self getTagsOjbectWithIndexPath:indexPath];
    
    
    CGRect frame = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.tagTextFont} context:nil];
    
    CGFloat width = frame.size.width+20;
    if ( width <= self.minItemWidth) {
        width = self.minItemWidth;
    }
    CGFloat height = frame.size.height + 10.0f;
    if ( height <= self.minItemHeigth) {
        height = self.minItemHeigth;
    }
    
    return CGSizeMake(width, height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JCTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = self.tagBackgroundColor;
    cell.layer.borderColor = self.tagStrokeColor.CGColor;
    cell.layer.cornerRadius = self.tagCornerRadius;
    
    cell.titleLabel.text = [self getTagsOjbectWithIndexPath:indexPath];
    cell.titleLabel.textColor = self.tagTextColor;
    cell.titleLabel.font = self.tagTextFont;
    
    if ([self.selectedTags containsObject:[self getTagsOjbectWithIndexPath:indexPath]]) {
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
                
                [self.selectedTags addObject:[self getTagsOjbectWithIndexPath:indexPath]];
                
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
                    [self.selectedTags addObject:[self getTagsOjbectWithIndexPath:indexPath]];
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
            
            if ([self.selectedTags containsObject:[self getTagsOjbectWithIndexPath:indexPath]]) {
                cell.backgroundColor = self.tagBackgroundColor;
                cell.titleLabel.textColor = self.tagTextColor;
                cell.layer.borderColor = self.tagStrokeColor.CGColor;
                [self.selectedTags removeObject:[self getTagsOjbectWithIndexPath:indexPath]];
            }
            else {
                cell.backgroundColor = self.tagSelectedBackgroundColor;
                cell.titleLabel.textColor = self.tagSelectedTextColor;
                cell.layer.borderColor = self.tagSelectStrokeColor.CGColor;
                [self.selectedTags addObject:[self getTagsOjbectWithIndexPath:indexPath]];
            }
        }
    }
    
    if (self.selectedBlock) {
        self.selectedBlock(indexPath);
    }
}

#pragma mark - setter/getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        JCCollectionViewTagFlowLayout *layout = [[JCCollectionViewTagFlowLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = true;
        //        _collectionView.scrollEnabled = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[JCTagCell class] forCellWithReuseIdentifier:reuseIdentifier];
    }
    
    return _collectionView;
}

@end
