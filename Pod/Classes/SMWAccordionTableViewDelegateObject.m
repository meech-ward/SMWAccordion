//
//  SMWAccordionTableViewDelegateObject.m
//  SMWAccordion
//
//  Created by Sam Meech Ward on 2015-01-04.
//  Copyright (c) 2015 Sam Meech-Ward. All rights reserved.
//

#import "SMWAccordionTableViewDelegateObject.h"
#import "SMWAccordionTableView.h"

@implementation SMWAccordionTableViewDelegateObject


#pragma mark - Message forwarding

// Override responds to selecter to return true if either the accordion view or delegate respond to the selector
- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([self.accordionView respondsToSelector:aSelector] || [self.delegate respondsToSelector:aSelector]) {
        return YES;
    }
    return NO;
}

// Return a method signiture of the method identified by the selector
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature* signature = [self.accordionView methodSignatureForSelector:aSelector];
    if (!signature) {
        signature = [(NSObject*)self.delegate methodSignatureForSelector:aSelector];
    }
    return signature;
}

// Catch any selectors not implemented on this object and perform them on the delegate and accordion
// This method turns every protocol method into an optional method
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    // Get the passed in selector
    SEL selector = [anInvocation selector];

    // Check if the accordion view has implemented the selector
    if ([self.accordionView respondsToSelector:selector]) {
        // Perform the selector on the accordion
        [anInvocation invokeWithTarget:self.accordionView];
    }
    // Check if the delegate view has implemented the selector
    if ([self.delegate respondsToSelector:selector]) {
        // Perform the selector on the delegate
        [anInvocation invokeWithTarget:self.delegate];
    }
}

@end
