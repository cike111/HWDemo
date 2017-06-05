//
//  HWSelecorView.m
//  HWDemo
//
//  Created by hw on 2017/5/10.
//  Copyright © 2017年 Hw. All rights reserved.
//

#import "HWSelecorView.h"
#import "Masonry.h"
@implementation HWSelecorView
-(instancetype)initWithDate:(NSMutableArray*)dateSource{
    self = [super init];
    if (self) {
        self.dateSource = dateSource;
        [self createUI];
    }
    return self;
}
- (void)createUI{
    [self addSubview:self.table];
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}


#pragma mark- 懒加载
- (UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _table.dataSource = self;
        _table.delegate = self;
        _table.showsVerticalScrollIndicator = NO;
        _table.bounces = YES;
        [_table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"FXInfoArrowCell"];
//        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _table;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dateSource.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FXInfoArrowCell"];
    cell.textLabel.text = self.dateSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectBlock) {
        self.selectBlock(self.dateSource[indexPath.row]);
    }
}
@end
