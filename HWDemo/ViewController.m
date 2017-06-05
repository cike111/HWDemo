//
//  ViewController.m
//  HWDemo
//
//  Created by hw on 2017/5/10.
//  Copyright © 2017年 Hw. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"

@interface ViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSArray * arr;
@property (nonatomic,strong) NSArray * arr1;
@property (nonatomic,strong) UITableView * tabView ;
@property (nonatomic,strong) UITextField * feiled;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    self.arr = @[@"HWSelectorViewController",@"HWNavHeadViewController",@"HWImageController",@"HWGPUImageController"];
    self.arr1 = @[@"选择器",@"头部动画",@"图像处理",@"GPUImage"];
    self.tabView = [[UITableView alloc]init];
//    self.tabView.backgroundColor = [UIColor redColor];
    self.tabView.dataSource = self;
    self.tabView.delegate = self;
    [self.view addSubview:self.tabView];
    
    [self.tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)viewDidAppear:(BOOL)animated{
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        
    }
    cell.textLabel.text = self.arr1[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self selectController:self.arr[indexPath.row]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)selectController:(NSString *)vcn{
    Class cls = NSClassFromString(vcn);
    UIViewController * vc = [[cls alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
