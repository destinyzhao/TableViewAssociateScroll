//
//  ViewController.m
//  TableViewAssociateScroll
//
//  Created by Alex on 16/10/10.
//  Copyright © 2016年 Alex. All rights reserved.
//

#import "ViewController.h"
#import "LeftTableViewCell.h"
#import "RightTableViewCell.h"

#define leftCellIdentifier  @"leftCellIdentifier"
#define rightCellIdentifier @"rightCellIdentifier"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self registerCellWithXib];
}

- (void)registerCellWithXib
{
    [_leftTableView registerNib:[UINib nibWithNibName:@"LeftTableViewCell" bundle:nil] forCellReuseIdentifier:leftCellIdentifier];
    [_rightTableView registerNib:[UINib nibWithNibName:@"RightTableViewCell" bundle:nil] forCellReuseIdentifier:rightCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.leftTableView) {
        return 1;
    }
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.leftTableView) {
        return 40;
    }
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (tableView == self.leftTableView) {
       LeftTableViewCell  *leftCell = [tableView dequeueReusableCellWithIdentifier:leftCellIdentifier forIndexPath:indexPath];
        leftCell.typeNameLbl.text = [NSString stringWithFormat:@"%ld", indexPath.row];
        cell = leftCell;
    }
    else
    {
        RightTableViewCell  *rightCell = [tableView dequeueReusableCellWithIdentifier:rightCellIdentifier forIndexPath:indexPath];
        rightCell.nameLbl.text = [NSString stringWithFormat:@"第%ld组-第%ld行", indexPath.section, indexPath.row];
        cell = rightCell;
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if (tableView == self.rightTableView)
    {
        return [NSString stringWithFormat:@"第 %ld 组", section];
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView) {
        NSIndexPath *rightTableViewMoveToIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
        // 将右侧tableView 移动到指定位置
        [self.rightTableView selectRowAtIndexPath:rightTableViewMoveToIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        // 取消选中效果
        [self.rightTableView deselectRowAtIndexPath:rightTableViewMoveToIndexPath animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.leftTableView) {
        return;
    }
    
    // 取出显示在视图最靠上cell的indexPath
    NSIndexPath *topHeaderViewIndexpath = [[self.rightTableView indexPathsForVisibleRows] firstObject];
    
    // 左侧talbelView移动的indexPath
    NSIndexPath *leftTableViewMoveToIndexpath = [NSIndexPath indexPathForRow:topHeaderViewIndexpath.section inSection:0];
    
    // 移动左侧tableView到指定 indexPath居中显示
    [self.leftTableView selectRowAtIndexPath:leftTableViewMoveToIndexpath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

@end
