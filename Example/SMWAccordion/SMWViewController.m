//
//  SMWViewController.m
//  SMWAccordion
//
//  Created by Sam Meech-Ward on 11/23/2015.
//  Copyright (c) 2015 Sam Meech-Ward. All rights reserved.
//

#import "SMWViewController.h"

#import <SMWAccordion/SMWAccordion.h>

@interface SMWViewController () <SMWAccordionTableViewDelegate, SMWAccordionTableViewDataSource>

/// The main accordion table view to display all data.
@property (weak, nonatomic) IBOutlet SMWAccordionTableView *accordionView;

@end

@implementation SMWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Accordion

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"Row: %li", (long)indexPath.row];
    return cell;
}

- (UIView *)accordionView:(SMWAccordionTableView *)accordionView contentViewForRowAtIndexPath:(NSIndexPath *)indexPath {
    UILabel *view = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_accordionView.bounds), 200.0)];
    view.text = [NSString stringWithFormat:@"Accordion View: %li", (long)indexPath.row];
    return view;
}

@end
