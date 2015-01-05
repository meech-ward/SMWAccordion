//
//  SMWAccordionTableViewDataSourceObject.m
//  SMWAccordion
//
//  Created by Sam Meech Ward on 2015-01-04.
//  Copyright (c) 2015 Sam Meech-Ward. All rights reserved.
//

#import "SMWAccordionTableViewDataSourceObject.h"

@implementation SMWAccordionTableViewDataSourceObject

#pragma mark - Table View

#pragma mark Configuring a Table View

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        return [self.dataSource numberOfSectionsInTableView:tableView];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource tableView:tableView numberOfRowsInSection:section];
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    return [self.dataSource sectionIndexTitlesForTableView:tableView];
//}
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//    return [self.dataSource tableView:tableView sectionForSectionIndexTitle:title atIndex:index];
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return [self.dataSource tableView:tableView titleForHeaderInSection:section];
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
//    return [self.dataSource tableView:tableView titleForFooterInSection:section];
//}
//
//#pragma mark Inserting or Deleting Table Rows
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [self.dataSource tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
//}
//
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [self.dataSource tableView:tableView canEditRowAtIndexPath:indexPath];
//}
//
//#pragma mark Reordering Table Rows
//
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [self.dataSource tableView:tableView canMoveRowAtIndexPath:indexPath];
//}
//
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
//    return [self.dataSource tableView:tableView moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
//}

#pragma mark - Accordion View

#pragma mark Configuring an Accordion View

- (UIView *)accordionView:(SMWAccordionTableView *)accordionView contentViewForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataSource respondsToSelector:@selector(accordionView:contentViewForRowAtIndexPath:)]) {
        return [self.dataSource accordionView:accordionView contentViewForRowAtIndexPath:indexPath];
    }
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}

@end
