//
//  SKUViewController.m
//  设计模式
//
//  Created by viveco on 2018/1/23.
//  Copyright © 2018年 罗罗明祥. All rights reserved.
//

#import "SKUViewController.h"


static NSString *const kPQTestCollectionCellIden = @"TestCollectionCellIden";
static const NSInteger kPQTestButtonTag = 100;

@interface SKUViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

/**
 总的数据模型，来自后台
 */
@property (nonatomic, strong) NSArray<NSArray *> *dataArray;
/**
 可用的组合积的数组，来自后台
 */
@property (nonatomic, strong) NSArray *userAvailabilityArray;
/**
 选中的积，临时变量
 */
@property (nonatomic, strong) NSMutableArray *chooseSelectArray;

@end

@implementation SKUViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = @[
                       @[@"2",@"3", @"5"],
                       @[@"7",@"11",@"13",@"17"],
                       @[@"19",@"23",@"29"],
                       @[@"37",@"41", @"43",@"47"]
                       ];
    
    
    /**
     
     假设这些选中是 OK 的, 保证每一个都有的选
     2 * 7 * 19 * 37 = 9842
     2 * 11 * 23 * 37 = 18722
     2 * 17 * 19 * 43 = 27778
     2 * 13 * 23 * 41 = 24518
     
     3 * 13 * 23 * 43 = 38571
     3 * 17 * 29 * 43 = 63597
     3 * 17 * 29 * 47 = 69513
     3 * 7 * 23 * 47 = 22701
     
     5 * 11 * 19 * 37 = 38665
     5 * 17 * 23 * 43 = 84065
     5 * 7 * 23 * 41 = 33005
     5 * 17 * 29 * 47 = 115855
     
     
     */
    self.userAvailabilityArray = @[@"9842",@"18722",@"27778",@"24518",@"38571",@"63597",@"69513",@"22701",@"38665",@"33005",@"84065",@"115855"];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kPQTestCollectionCellIden];
    
//    [self.collectionView reloadData];
}

- (void)changeButtonStatus:(UIButton *)chooseButton {
    // 对选中状态取反
    chooseButton.selected = !chooseButton.selected;
    // 获取 button 的具体信息
    NSInteger selectSection = chooseButton.tag / kPQTestButtonTag  - 1;
    NSInteger selectRow = chooseButton.tag % kPQTestButtonTag - 1;
    
    if (chooseButton.selected) {
        // 选中的状态
        [self selectSomeButtonWithSection:selectSection row:selectRow chooseButtonTag:chooseButton.tag];
    }
    else {
        // 取反的状态
        [self unSelectSomeButtonWithSection:selectSection row:selectRow chooseButtonTag:chooseButton.tag];
    }
}

/**
 选中某个
 */
- (void)selectSomeButtonWithSection:(NSInteger)selectSection row:(NSInteger)selectRow chooseButtonTag:(NSInteger)chooseButtonTag {
    // 先判断如果是同一行的话
    [self.dataArray enumerateObjectsUsingBlock:^(NSArray * _Nonnull obj, NSUInteger sectionIdx, BOOL * _Nonnull sectionStop) {
        if (selectSection == sectionIdx) {
            // 对同一种类型进行互斥
            [self.dataArray[selectSection] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger rowIdx, BOOL * _Nonnull stop) {
                // 获取与之对应的 Cell 中的 Button
                UIButton *button = [self getCellWithSection:selectSection row:rowIdx];
                // 假如是同一行的其他标签，而且是选中状态
                if (button.tag != chooseButtonTag && button.selected) {
                    // 将上一个选中设置为普通
                    button.selected = NO;
                    // 同时移除上一次的选中的值
                    [self.chooseSelectArray removeObject:self.dataArray[selectSection][rowIdx]];
                }
            }];
            *sectionStop = YES;
        }
    }];
    // 再判断其他种行种类的, 是否 可用
    [self.chooseSelectArray addObject:self.dataArray[selectSection][selectRow]];
    NSInteger allValueIntger = [self getChooseSelectValue];
    [self.dataArray enumerateObjectsUsingBlock:^(NSArray * _Nonnull obj, NSUInteger sectionIdx, BOOL * _Nonnull stop) {
        if (selectSection != sectionIdx) {
            // 不是选中的这一行，则刷新 是否可用
            __block NSInteger hadSelectValue = 1;
            if (self.chooseSelectArray.count > 1) {
                [self.dataArray[sectionIdx] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger rowIdx, BOOL * _Nonnull rowStop) {
                    if ([self.chooseSelectArray containsObject:obj]) {
                        hadSelectValue = [obj integerValue];
                        *rowStop = YES;
                    }
                }];
            }
            [self.dataArray[sectionIdx] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger rowIdx, BOOL * _Nonnull rowStop) {
                // 获取与之对应的 Cell 中的 Button
                UIButton *button = [self getCellWithSection:sectionIdx row:rowIdx];
                // 获取当前的 Value
                NSInteger buttonValueInter = [self.dataArray[sectionIdx][rowIdx] integerValue];
                // 就是没有选中
                if (!button.selected) {
                    [self.userAvailabilityArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        button.enabled = NO;
                        if (([obj integerValue] % (allValueIntger * buttonValueInter / hadSelectValue)) == 0) {
                            button.enabled = YES;
                            *stop = YES;
                        }
                    }];
                }
            }];
        }
    }];
}

/**
 取反某个
 */
- (void)unSelectSomeButtonWithSection:(NSInteger)selectSection row:(NSInteger)selectRow chooseButtonTag:(NSInteger)chooseButtonTag {
    [self.chooseSelectArray removeObject:self.dataArray[selectSection][selectRow]];
    NSInteger allValueIntger = [self getChooseSelectValue];
    [self.dataArray enumerateObjectsUsingBlock:^(NSArray * _Nonnull obj, NSUInteger sectionIdx, BOOL * _Nonnull stop) {
        if (selectSection != sectionIdx) {
            [self.dataArray[sectionIdx] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger rowIdx, BOOL * _Nonnull rowStop) {
                __block NSInteger hadSelectValue = 1;
                [self.dataArray[sectionIdx] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger rowIdx, BOOL * _Nonnull rowStop) {
                    if ([self.chooseSelectArray containsObject:obj]) {
                        hadSelectValue = [obj integerValue];
                        *rowStop = YES;
                    }
                }];
                [self.dataArray[sectionIdx] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger rowIdx, BOOL * _Nonnull rowStop) {
                    // 获取与之对应的 Cell 中的 Button
                    UIButton *button = [self getCellWithSection:sectionIdx row:rowIdx];
                    // 获取当前的 Value
                    NSInteger buttonValueInter = [self.dataArray[sectionIdx][rowIdx] integerValue];
                    // 就是没有选中
                    if (!button.selected) {
                        [self.userAvailabilityArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            button.enabled = NO;
                            if (([obj integerValue] % (allValueIntger / hadSelectValue * buttonValueInter)) == 0) {
                                button.enabled = YES;
                                *stop = YES;
                            }
                        }];
                    }
                }];
                
            }];
        }
    }];
}

/**
 获取相对应的 Cell 中的 Button 按钮
 */
- (UIButton *)getCellWithSection:(NSInteger)section row:(NSInteger)row {
    // 获取与之对应的 Cell
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    // 获取与之对应的 Button
    UIButton *button = (UIButton *)[cell viewWithTag:(kPQTestButtonTag * (section + 1) + (row + 1))];
    return button;
}


/**
 获取已经选中的 Value 乘积
 */
- (long long)getChooseSelectValue {
    __block long long hadChooseValue = 1;
    [self.chooseSelectArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        hadChooseValue *= [obj integerValue];
    }];
    return hadChooseValue;
}

/**
 获取可用的 数组 Value
 */
- (NSArray *)getCanUseArrayWithSelect:(BOOL)select {
    
    long long chooseAllValue = [self getChooseSelectValue];
    /**
     chooseAllValue == 1 表示为空
     self.chooseSelectArray.count == 1 && !select： 取反时只剩下一个的时候
     */
    if (chooseAllValue == 1 || (self.chooseSelectArray.count == 1 && !select)) {
        return self.userAvailabilityArray;
    }
    NSMutableArray *useArray = [NSMutableArray array];
    
    [self.userAvailabilityArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger useInteger = [obj integerValue];
        if ((useInteger % chooseAllValue) == 0) {
            [useArray addObject:obj];
        }
    }];
    return useArray.copy;
}

#pragma mark - Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return  self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray[section].count;;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPQTestCollectionCellIden forIndexPath:indexPath];
    // 显示 �UIButton
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = cell.bounds; // 此处先写死，size 先设置个 60、50
    [button setTitle:(self.dataArray[indexPath.section][indexPath.row]) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button pq_setBackgroundColor:[UIColor orangeColor] state:UIControlStateSelected];
    [button pq_setBackgroundColor:[UIColor blackColor] state:UIControlStateNormal];
    [button pq_setBackgroundColor:[UIColor grayColor] state:UIControlStateDisabled];
    button.tag = kPQTestButtonTag * (indexPath.section + 1) + (indexPath.row + 1);
    [button addTarget:self action:@selector(changeButtonStatus:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:button];
    
    return cell;
}

#pragma mark - Getter
- (NSMutableArray *)chooseSelectArray {
    if (!_chooseSelectArray) {
        _chooseSelectArray = [NSMutableArray array];
    }
    return _chooseSelectArray;
}


@end

@implementation UIButton (PQBackgroundColor)

- (void)pq_setBackgroundColor:(UIColor *)color state:(UIControlState)state {
    [self setBackgroundImage:[self pq_imageWithColor:color] forState:state];
}

- (UIImage *)pq_imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end

