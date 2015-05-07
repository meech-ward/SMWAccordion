# SMWAccordion

![SMWAccordion Preview](http://www.sammeechward.com/assets/SMWAccordion/preview.gif)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Documentation

Check out the [documentation](http://www.sammeechward.com/library/ios/documentation/SMWAccordion/) for a comprehensive look at SMWAccordion.

## Installation

SMWAccordion is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "SMWAccordion"

## Author

Sam Meech-Ward, sam@meech-ward.com

## License

SMWAccordion is available under the MIT license. See the LICENSE file for more info.

## How to use

Import the SMWAccordion header


    #import <SMWAccordion/SMWAccordion.h>

Setup a SMWAccordionTableView exactly the same way that you would set up a UITableView.

Instead of using the UITableView protocols, use the SMWAccordionTableView protocols

    <SMWAccordionTableViewDelegate, SMWAccordionTableViewDataSource>

Implement the folowing datasource protocol method

    - (UIView *)accordionView:(SMWAccordionTableView *)accordionView contentViewForRowAtIndexPath:(NSIndexPath *)indexPath;

Use this method to return the content view that you want to be shown by the accordion.
This view has to be shorter than the accordion view itself otherwise the accordion will close strait after opening.
It is a good idea to keep the content view no taller than half the size of the accordion view.
If it is necessary to display a view that is taller, return a scrollview with the content inside it.

Optional delegate methods:

    - (void)accordionViewWillClose:(SMWAccordionTableView *)accordionView;
    - (void)accordionViewDidClose:(SMWAccordionTableView *)accordionView;
    - (void)accordionViewWillOpen:(SMWAccordionTableView *)accordionView;
    - (void)accordionViewDidOpen:(SMWAccordionTableView *)accordionView;

