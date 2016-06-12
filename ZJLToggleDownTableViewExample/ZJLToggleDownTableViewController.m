//
//  ZJLToggleDownTableViewController.m
//  ZJLToggleDownTableViewExample
//
//  Created by ZhongZhongzhong on 16/6/11.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "ZJLToggleDownTableViewController.h"
#import "ViewController.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface ZJLToggleDownTableViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *headerArray;
@property (nonatomic, strong) NSMutableDictionary *sectionDic;
@property (nonatomic, strong) NSMutableArray *headerStatusArray;
@end

@implementation ZJLToggleDownTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.headerArray = [NSMutableArray arrayWithObjects:@"Montreal",@"Toronto",@"Ottawa",@"Winnipeg",@"Calgary", nil];
    self.headerStatusArray = [NSMutableArray arrayWithObjects:@NO,@NO,@NO,@NO,@NO, nil];
    self.sectionDic = [[NSMutableDictionary alloc] init];
    NSArray *array1 = [NSArray arrayWithObjects:@"Old port",@"Royal Mountain",@"Place des art", nil];
    NSArray *array2 = [NSArray arrayWithObjects:@"CN tower",@"Queen St",@"King St",@"Dundas",@"lake", nil];
    NSArray *array3 = [NSArray arrayWithObjects:@"Congress",@"small", nil];
    NSArray *array4 = [NSArray arrayWithObjects:@"Mcdonald",@"KFC", nil];
    NSArray *array5 = [NSArray arrayWithObjects:@"University Alberta", nil];
    [self.sectionDic setObject:array1 forKey:[self.headerArray objectAtIndex:0]];
    [self.sectionDic setObject:array2 forKey:[self.headerArray objectAtIndex:1]];
    [self.sectionDic setObject:array3 forKey:[self.headerArray objectAtIndex:2]];
    [self.sectionDic setObject:array4 forKey:[self.headerArray objectAtIndex:3]];
    [self.sectionDic setObject:array5 forKey:[self.headerArray objectAtIndex:4]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.headerArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[self.headerStatusArray objectAtIndex:section] boolValue]) {
        return [[self.sectionDic objectForKey:[self.headerArray objectAtIndex:section]] count];
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    headerView.tag = section;
    headerView.contentView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, ScreenWidth-60, 30)];
    if ([[self.headerStatusArray objectAtIndex:section] boolValue]) {
        titleLabel.text = [NSString stringWithFormat:@"%@   detail",[self.headerArray objectAtIndex:section]];
        headerView.contentView.backgroundColor = [UIColor grayColor];
    }else{
        titleLabel.text = [NSString stringWithFormat:@"%@",[self.headerArray objectAtIndex:section]];
    }
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor blackColor];
    [headerView addSubview:titleLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTap:)];
    [headerView addGestureRecognizer:tap];
    
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-50, 10, 30, 30)];
    arrow.image = [UIImage imageNamed:@"arrow"];
    arrow.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [headerView addSubview:arrow];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectZero];
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.headerStatusArray objectAtIndex:indexPath.section] boolValue]) {
        return 30;
    }else{
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ViewController *vc = (ViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"vc"];
    NSArray *detail = [self.sectionDic objectForKey:[self.headerArray objectAtIndex:indexPath.section]];
    vc.title = [detail objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)headerTap:(UITapGestureRecognizer *)tap
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:tap.view.tag];
    UIView *headerView = [self.tableView headerViewForSection:indexPath.section];
    UIImageView *imageView;
    for (UIView *view in headerView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            imageView = (UIImageView *)view;
        }
    }
    BOOL isShow = [[self.headerStatusArray objectAtIndex:indexPath.section] boolValue];
    if (indexPath.row == 0) {
        isShow = !isShow;
        [self.headerStatusArray replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:isShow]];
        
        [self arrowAnimation:imageView completion:nil];
        
        NSRange range = NSMakeRange(indexPath.section, 1);
        NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.tableView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationFade];
    }
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    BOOL isShow = [[self.headerStatusArray objectAtIndex:indexPath.section] boolValue];
    if (!isShow) {
        cell.textLabel.text = @"show";
    }else{
        NSArray *detail = [self.sectionDic objectForKey:[self.headerArray objectAtIndex:indexPath.section]];
        cell.textLabel.text = [detail objectAtIndex:indexPath.row];
    }
    // Configure the cell...
    
    return cell;
}

- (void)arrowAnimation:(UIImageView *)imageView completion:(void(^)())block
{
    [UIView animateWithDuration:0.3 animations:^{
        imageView.transform = CGAffineTransformMakeRotation(M_PI);
    } completion:^(BOOL finished) {
        imageView.transform = CGAffineTransformMakeRotation(0);
        if (block) {
            block();
        }
    }];
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
