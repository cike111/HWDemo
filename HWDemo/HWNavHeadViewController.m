//
//  HWNavHeadViewController.m
//  HWDemo
//
//  Created by hw on 2017/5/17.
//  Copyright © 2017年 Hw. All rights reserved.
//

#import "HWNavHeadViewController.h"

@interface HWNavHeadViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView * myTabelView;
@end

@implementation HWNavHeadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.automaticallyAdjustsScrollViewInsets = YES;
    self.title = @"动画";
    [self.view addSubview:self.myTabelView];
    
    [self.myTabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    
    // Do any additional setup after loading the view.
}

- (UITableView *)myTabelView
{
    if (!_myTabelView) {
        _myTabelView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _myTabelView.dataSource = self;
        _myTabelView.delegate = self;
        _myTabelView.showsVerticalScrollIndicator = NO;
        _myTabelView.tableHeaderView = [self setHeadview];
        _myTabelView.bounces = NO;
        _myTabelView.backgroundColor = [UIColor redColor];
        [_myTabelView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"FXInfoArrowCell"];
//        _myTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _myTabelView;
}

- (UIView*)setHeadview{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width , 100)];
    view.backgroundColor = [UIColor cyanColor];
    UIView * leftView = [[UIView alloc]init];
    leftView.backgroundColor = [UIColor blueColor];
    [view addSubview:leftView];
    
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view);
        make.height.width.equalTo(@(50));
    }];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FXInfoArrowCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat H =100.0-scrollView.contentOffset.y;
    self.myTabelView.tableHeaderView.frame = CGRectMake(0, 0, self.view.frame.size.width,H);
   
//    self.myTabelView.tableHeaderView.frame
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
