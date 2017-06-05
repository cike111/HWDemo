//
//  HWSelecorView.h
//  HWDemo
//
//  Created by hw on 2017/5/10.
//  Copyright © 2017年 Hw. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^selectBlock)(NSString *code);
@interface HWSelecorView : UIView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UITableView * table;
@property(nonatomic,strong) NSMutableArray * dateSource;
@property(nonatomic,copy) selectBlock  selectBlock;
-(instancetype)initWithDate:(NSMutableArray*)dateSource;
@end
