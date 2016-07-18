//
//  FDSlideBar.m
//  BeiLu
//
//  Created by YKJ1 on 16/4/7.
//  Copyright © 2016年 YKJ1. All rights reserved.
//

#import "FDSlideBar.h"
#import "FDSlideBarItem.h"


#define DEFAULT_SLIDER_COLOR [UIColor orangeColor]
//提示线高度
#define SLIDER_VIEW_HEIGHT 3
#define kImageWidth 24
@interface FDSlideBar () <FDSlideBarItemDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) UIView *sliderView;

@property (strong, nonatomic) FDSlideBarItem *selectedItem;
@property (strong, nonatomic) FDSlideBarItemSelectedCallback callback;

@end

@implementation FDSlideBar

#pragma mark - Lifecircle

- (instancetype)init {
    CGRect frame = CGRectMake(0, 0, kScreenWidth, 46);
    return [self initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        _items = [NSMutableArray array];
        [self initScrollView];
        [self initSliderView];
    }
    return self;
}

#pragma - mark Custom Accessors

- (void)setItemsTitle:(NSArray *)itemsTitle {
    _itemsTitle = itemsTitle;
    [self setupItems];
}

- (void)setItemColor:(UIColor *)itemColor {
    for (FDSlideBarItem *item in _items) {
        [item setItemTitleColor:itemColor];
    }
}

- (void)setItemSelectedColor:(UIColor *)itemSelectedColor {
    for (FDSlideBarItem *item in _items) {
        [item setItemSelectedTitleColor:itemSelectedColor];
    }
}

- (void)setSliderColor:(UIColor *)sliderColor {
    _sliderColor = sliderColor;
    self.sliderView.backgroundColor = _sliderColor;
}

- (void)setSelectedItem:(FDSlideBarItem *)selectedItem {
    _selectedItem.selected = NO;
    _selectedItem = selectedItem;
}

- (void)setItemBackgroundColor:(UIColor *)color {
    _scrollView.backgroundColor = color;
}

#pragma - mark Private

- (void)initScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.scrollsToTop = NO;
    [self addSubview:_scrollView];
}

- (void)initSliderView {
    _sliderView = [[UIView alloc] init];
    _sliderColor = DEFAULT_SLIDER_COLOR;
    _sliderView.backgroundColor = _sliderColor;
    [_scrollView addSubview:_sliderView];
}

//提示显示
- (void)setupItems {
    
    CGFloat itemX = 0;
    for (NSString *title in _itemsTitle) {
        FDSlideBarItem *item = [[FDSlideBarItem alloc] init];
        item.delegate = self;
      
        if ([title hasSuffix: @".png"]){
            // Init the current item's frame
            CGFloat itemW = [FDSlideBarItem widthForTitle:@"shop.png"];
            item.frame = CGRectMake(itemX, 0, itemW, CGRectGetHeight(_scrollView.frame));
            
            UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake((itemW-kImageWidth)/2,(CGRectGetHeight(_scrollView.frame)-kImageWidth)/2,kImageWidth,kImageWidth)];
            [bgImgView setImage: [UIImage imageNamed:@"shop.png"]];
            bgImgView.contentMode = UIViewContentModeScaleAspectFit;
            [item addSubview:bgImgView];
            [item sendSubviewToBack:bgImgView];
            
            [_items addObject:item];
            
            [_scrollView addSubview:item];
            
            // Caculate the origin.x of the next item
            itemX = CGRectGetMaxX(item.frame);

        }else{
            // Init the current item's frame
            CGFloat itemW = [FDSlideBarItem widthForTitle:title];
            
            item.frame = CGRectMake(itemX, 0, itemW, CGRectGetHeight(_scrollView.frame));
            [item setItemTitle:title];
            [_items addObject:item];
            
            [_scrollView addSubview:item];
            
            // Caculate the origin.x of the next item
            itemX = CGRectGetMaxX(item.frame);
        }
    }
    
    // Cculate the scrollView 's contentSize by all the items
    _scrollView.contentSize = CGSizeMake(itemX, CGRectGetHeight(_scrollView.frame));
    
    // Set the default selected item, the first item
    FDSlideBarItem *firstItem = [self.items firstObject];
    firstItem.selected = YES;
    _selectedItem = firstItem;
    
    // Set the frame of sliderView by the selected item
    _sliderView.frame = CGRectMake(0, self.frame.size.height - SLIDER_VIEW_HEIGHT, firstItem.frame.size.width, SLIDER_VIEW_HEIGHT);
    

}

- (void)scrollToVisibleItem:(FDSlideBarItem *)item {
//    NSInteger selectedItemIndex = [self.items indexOfObject:_selectedItem];
//    NSInteger visibleItemIndex = [self.items indexOfObject:item];
//    
//    // If the selected item is same to the item to be visible, nothing to do
//    if (selectedItemIndex == visibleItemIndex) {
//        return;
//    }
//    
//    CGPoint offset = _scrollView.contentOffset;
//    
//    // If the item to be visible is in the screen, nothing to do
//    if (CGRectGetMinX(item.frame) >= offset.x && CGRectGetMaxX(item.frame) <= (offset.x + CGRectGetWidth(_scrollView.frame))) {
//        return;
//    }
//    
//    // Update the scrollView's contentOffset according to different situation
//    if (selectedItemIndex < visibleItemIndex) {
//        // The item to be visible is on the right of the selected item and the selected item is out of screeen by the left, also the opposite case, set the offset respectively
//        if (CGRectGetMaxX(_selectedItem.frame) < offset.x) {
//            offset.x = CGRectGetMinX(item.frame);
//        } else {
//            offset.x = CGRectGetMaxX(item.frame) - CGRectGetWidth(_scrollView.frame);
//        }
//    } else {
//        // The item to be visible is on the left of the selected item and the selected item is out of screeen by the right, also the opposite case, set the offset respectively
//        if (CGRectGetMinX(_selectedItem.frame) > (offset.x + CGRectGetWidth(_scrollView.frame))) {
//            offset.x = CGRectGetMaxX(item.frame) - CGRectGetWidth(_scrollView.frame);
//        } else {
//            offset.x = CGRectGetMinX(item.frame);
//        }
//    }
    
    //滑块滑动
    CGPoint offset = _scrollView.contentOffset;
    CGSize size = _scrollView.contentSize;
    
    FDSlideBarItem *endItem = [self.items lastObject];
    
    if(CGRectGetMaxX(endItem.frame)>kScreenWidth){
        if (CGRectGetMinX(item.frame)<100) {
            offset.x = 0;
        }else if(size.width-CGRectGetMinX(item.frame)<CGRectGetWidth(_scrollView.frame)-50){
            offset.x = size.width - CGRectGetWidth(_scrollView.frame);
        }else{
            offset.x = CGRectGetMidX(item.frame)-100;
        }
        [_scrollView setContentOffset:offset animated:YES];
    }
}

- (void)addAnimationWithSelectedItem:(FDSlideBarItem *)item {
    // Caculate the distance of translation
    CGFloat dx = CGRectGetMidX(item.frame) - CGRectGetMidX(_selectedItem.frame);
    
    // Add the animation about translation
    CABasicAnimation *positionAnimation = [CABasicAnimation animation];
    positionAnimation.keyPath = @"position.x";
    positionAnimation.fromValue = @(_sliderView.layer.position.x);
    positionAnimation.toValue = @(_sliderView.layer.position.x + dx);
    
    // Add the animation about size
    CABasicAnimation *boundsAnimation = [CABasicAnimation animation];
    boundsAnimation.keyPath = @"bounds.size.width";
    boundsAnimation.fromValue = @(CGRectGetWidth(_sliderView.layer.bounds));
    boundsAnimation.toValue = @(CGRectGetWidth(item.frame));
    
    // Combine all the animations to a group
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[positionAnimation, boundsAnimation];
    animationGroup.duration = 0.2;
    [_sliderView.layer addAnimation:animationGroup forKey:@"basic"];
    
    // Keep the state after animating
    _sliderView.layer.position = CGPointMake(_sliderView.layer.position.x + dx, _sliderView.layer.position.y);
    CGRect rect = _sliderView.layer.bounds;
    rect.size.width = CGRectGetWidth(item.frame);
    _sliderView.layer.bounds = rect;
}

#pragma mark - Public

- (void)slideBarItemSelectedCallback:(FDSlideBarItemSelectedCallback)callback {
    _callback = callback;
}
//滑动界面
- (void)selectSlideBarItemAtIndex:(NSUInteger)index {
    FDSlideBarItem *item = [self.items objectAtIndex:index];
    if (item == _selectedItem) {
        return;
    }
    item.selected = YES;
    [self scrollToVisibleItem:item];
    [self addAnimationWithSelectedItem:item];
    self.selectedItem = item;

}

#pragma mark - FDSlideBarItemDelegate
//点击按键
- (void)slideBarItemSelected:(FDSlideBarItem *)item {
//    if (item == _selectedItem) {
//        return;
//    }
    [self scrollToVisibleItem:item];
    [self addAnimationWithSelectedItem:item];
    self.selectedItem = item;
    _callback([self.items indexOfObject:item]);

}

@end
