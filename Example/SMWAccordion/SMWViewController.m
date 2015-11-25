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
    self.accordionView.delegate = self;
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

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
     NSLog(@"did de-select row");
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.alpha = 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did select row");
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.alpha = 0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"will display cell:");
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did un display cell:");
}

@end
