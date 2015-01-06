//
//  MessageViewController.m
//  QQTableViewSimulate
//
//  Created by ZHENGBO on 15/1/6.
//  Copyright (c) 2015年 WeiPengwei. All rights reserved.
//

#import "MessageViewController.h"
#import "SectionHeaderObject.h"
#import "TableViewObject.h"
#import "TableViewHeaderView.h"
@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate,TableViewHeaderDelegate> {

    UITableView *listmanTableView;
    NSArray *cellsArray;
}

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"消息";
    
    listmanTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenHeight, ScreenHeight-53) style:UITableViewStylePlain];
    listmanTableView.backgroundColor = [UIColor clearColor];
    listmanTableView.delegate = self;
    listmanTableView.dataSource = self;
    [self.view addSubview:listmanTableView];
    listmanTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    listmanTableView.sectionHeaderHeight = 44;
    
    [NSThread detachNewThreadSelector:@selector(getTableCellDatas) toTarget:self withObject:nil];
}

- (void)getTableCellDatas {
    if (!cellsArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"friendsList.plist" ofType:nil];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *muArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in array) {
            SectionHeaderObject *HeaderObject = [SectionHeaderObject initWithDictionary:dict];
            [muArray addObject:HeaderObject];
        }
        cellsArray = [[NSArray alloc] initWithArray:muArray];
    }
    [listmanTableView reloadData];
}

#pragma - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    SectionHeaderObject *object = [cellsArray objectAtIndex:section];
    if (object.isFold) {
        return 0;
    }
    return object.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    SectionHeaderObject *headerObject = [cellsArray objectAtIndex:indexPath.section];
    TableViewObject *object = [headerObject.friends objectAtIndex:indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:@"jingtian"];
    cell.imageView.layer.cornerRadius = 20;
    cell.imageView.layer.masksToBounds = YES;
    
    cell.textLabel.text = object.name;
    cell.detailTextLabel.text = object.say;
    
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return cellsArray.count;
}

#pragma - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    TableViewHeaderView *headerView = [TableViewHeaderView initWithHeaderView:tableView];
    headerView.delegate = self;
    headerView.headerObject = [cellsArray objectAtIndex:section];
   
    return headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (void)clickedAction:(TableViewHeaderView*)headerView {
    [listmanTableView reloadData];
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
