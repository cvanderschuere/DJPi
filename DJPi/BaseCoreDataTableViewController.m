//
//  BaseCoreDataTableViewController.m
//  DJPi
//
//  Created by Chris Vanderschuere on 1/25/13.
//  Copyright (c) 2013 CDVConcepts. All rights reserved.
//

#import "BaseCoreDataTableViewController.h"

@interface BaseCoreDataTableViewController ()

@end

@implementation BaseCoreDataTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = [UIColor lightGrayColor];
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.sectionHeaderHeight)];
    [header setBackgroundColor:[UIColor lightGrayColor]];
    header.textColor = [UIColor whiteColor];
    header.text = [@"\t" stringByAppendingString:[self tableView:tableView titleForHeaderInSection:section]];
    
    return header;
}

@end
