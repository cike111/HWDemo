//
//  HWSelectorViewController.m
//  textFieldDemo
//
//  Created by hw on 2017/5/10.
//  Copyright © 2017年 HW. All rights reserved.
//

#import "HWSelectorViewController.h"
#import "Masonry.h"
#import "HWSelecorView.h"
@interface HWSelectorViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView * myTabelView;
@property(nonatomic,strong) HWSelecorView * selectView;
@property(nonatomic,strong) NSMutableArray * cradNumArr;
@property(nonatomic,copy) NSString  * carNum;
@end

@implementation HWSelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择器";
    [self.view addSubview:self.myTabelView];
    self.carNum = @"111111";
    [self.myTabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    // Do any additional setup after loading the view.
}
#pragma mark- 懒加载

- (NSMutableArray*)cradNumArr{
    if (!_cradNumArr) {
        _cradNumArr = [[NSMutableArray alloc]initWithCapacity:0];
        [_cradNumArr addObject:@"wwwwww"];
        [_cradNumArr addObject:@"rrrrrr"];
        [_cradNumArr addObject:@"tttttt"];
        [_cradNumArr addObject:@"wwwwww"];
        [_cradNumArr addObject:@"rrrrrr"];
        [_cradNumArr addObject:@"tttttt"];
    }
    return _cradNumArr;
}

- (UITableView *)myTabelView
{
    if (!_myTabelView) {
        _myTabelView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _myTabelView.dataSource = self;
        _myTabelView.delegate = self;
        _myTabelView.showsVerticalScrollIndicator = NO;
        _myTabelView.bounces = YES;
//        _myTabelView.backgroundColor = kTableViewBgColor;
//        _myTabelView.tableFooterView = [self setTableViewFoorterView];
//        _myTabelView.tableHeaderView = [self setTableViewHeaderView];
//        [self tabelViewAddtap:_myTabelView];
        [_myTabelView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"FXInfoArrowCell"];
        _myTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _myTabelView;
}

- (HWSelecorView*)selectView{
    if (!_selectView) {
        _selectView = [[HWSelecorView alloc] initWithDate:self.cradNumArr];
    }
    return _selectView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   return  50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FXInfoArrowCell"];
    cell.textLabel.text = self.carNum;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view addSubview:self.selectView];
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.myTabelView.mas_top).offset(64+(indexPath.row+1)*50);
        make.centerX.left.equalTo(self.view);
        make.height.equalTo(@(250));
    }];
    __weak typeof(self) weakSelf = self;
    self.selectView.selectBlock= ^(NSString *code){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.text = code;
        weakSelf.carNum = code;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [weakSelf.selectView removeFromSuperview];
    };
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
