//
//  ViewController.m
//  ZZQEmptyViewDemo
//
//  Created by 郑志强 on 2018/3/5.
//  Copyright © 2018年 郑志强. All rights reserved.
//

#import "ViewController.h"
#import "ZZQEmptyView.h"
#import "DetailViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) NSArray *titles;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.titles = @[@"normal",@"customImage",@"customText",@"customBtn"];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellDentifier = @"cellDentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellDentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellDentifier];
    }
    
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.navigationItem.title = self.titles[indexPath.row];

    [self.navigationController pushViewController:detailVC animated:YES];
}



@end
