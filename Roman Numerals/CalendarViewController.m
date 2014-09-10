//
//  DateViewController.m
//  Roman Numerals
//
//  Created by Robert Clarke on 16/02/2014.
//  Copyright (c) 2014 Robert Clarke. All rights reserved.
//

#import "CalendarViewController.h"
#import "RomanNumsActivityItemProvider.h"
#import "Converter.h"

#define kPickerAnimationDuration    0.40   // duration for the animation to slide the date picker into view
#define kDatePickerTag              99     // view tag identifiying the date picker view

#define kTitleKey       @"title"   // key for obtaining the data source item's title
#define kDateKey        @"date"    // key for obtaining the data source item's date value
#define kModeKey        @"mode"    // key for obtaining the data source item's presentation mode

// keep track of which rows have date cells
#define kDateStartRow   1
#define kDateEndRow     4

static NSString *kDateCellID = @"dateCell";     // the cells with the start or end date
static NSString *kDatePickerID = @"datePicker"; // the cell containing the date picker
static NSString *kOtherCell = @"otherCell";     // the remaining cells at the end

#pragma mark -

@interface CalendarViewController ()

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

// keep track which indexPath points to the cell with UIDatePicker
@property (nonatomic, strong) NSIndexPath *datePickerIndexPath;

@property (assign) NSInteger pickerCellRowHeight;

@property (nonatomic, strong) IBOutlet UIDatePicker *pickerView;

// this button appears only when the date picker is shown (iOS 6.1.x or earlier)
@property (nonatomic, strong) IBOutlet UIBarButtonItem *doneButton;

@end

#pragma mark -

@implementation CalendarViewController

/*! Primary view has been loaded for this view controller
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];    // show short-style date format
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    

    // if the local changes while in the background, we need to be notified so we can update the date
    // format in the table view cells
    //
    /*[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(localeChanged:)
                                                 name:NSCurrentLocaleDidChangeNotification
                                               object:nil];*/
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSCurrentLocaleDidChangeNotification
                                                  object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareButton:)];
    
    [self.tabBarController.navigationItem setRightBarButtonItem:shareButton];
    
    [self.tabBarController.navigationItem setTitle:@"Calendar"];
    
    [self convertDateToRoman];
}

#pragma mark - Locale

#pragma mark - Actions

- (void)convertDateToRoman
{
    NSUserDefaults *preferences = [[NSUserDefaults alloc] initWithSuiteName:@"group.it.kumo.roman"];

    NSString *locale = [[NSLocale currentLocale] localeIdentifier];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[_datePicker date]];
    
    NSString *day = [NSString stringWithFormat:@"%ld", (long)[components day]];
    NSString *month = [NSString stringWithFormat:@"%ld", (long)[components month]];
    NSString *year = [NSString stringWithFormat:@"%ld", (long)[components year]];
    
    bool yearFormat = [[preferences valueForKey:kYearFormatKey] boolValue];
    
    if (yearFormat == NO) {
        year = [NSString stringWithFormat:@"%ld", (long)([components year] % 100)];
    }
    
    Converter *converter = [[Converter alloc] init];
    
    NSString *romanDay = [converter performSimpleConversionToRoman:day];
    NSString *romanMonth = [converter performSimpleConversionToRoman:month];
    NSString *romanYear = [converter performSimpleConversionToRoman:year];
    
    int dateFormat = [[preferences valueForKey:kDateFormatKey] intValue];
    
    NSString *format = @".";
    
    if (dateFormat == 1) {
        format = @"-";
    } else if (dateFormat == 2) {
        format = @" ";
    }

    int dateOrder = [[preferences valueForKey:kDateOrderKey] intValue];
    
    if (dateOrder == 0) {
        if ([locale isEqualToString:@"en_US"]) {
            dateOrder = 2;
        } else {
            dateOrder = 1;
        }
    }
        
    if (dateOrder == 1) {
        [_dateLabel setText:[NSString stringWithFormat:@"%@\u200B%@\u200B%@\u200B%@\u200B%@", romanDay, format, romanMonth, format, romanYear]];
        [_dateLabel setAccessibilityLabel:[NSString stringWithFormat:@"%@ - %@ - %@", romanDay, romanMonth, romanYear]];
    } else if (dateOrder == 2) {
        [_dateLabel setText:[NSString stringWithFormat:@"%@\u200B%@\u200B%@\u200B%@\u200B%@", romanMonth, format, romanDay, format, romanYear]];
        [_dateLabel setAccessibilityLabel:[NSString stringWithFormat:@"%@ - %@ - %@", romanMonth, romanDay, romanYear]];
    }
    
    NSMutableString* spacedResult = [_dateLabel.text mutableCopy];
    [spacedResult enumerateSubstringsInRange:NSMakeRange(0, [spacedResult length])
                               options:NSStringEnumerationByComposedCharacterSequences | NSStringEnumerationSubstringNotRequired
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){
                                if (substringRange.location > 0)
                                    [spacedResult insertString:@". " atIndex:substringRange.location];
                            }];

    [_dateLabel setAccessibilityLabel:spacedResult];
    
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, [NSString stringWithFormat:@"Result: %@", spacedResult]);
}

/*! User chose to change the date by changing the values inside the UIDatePicker.
 
 @param sender The sender for this action: UIDatePicker.
 */
- (IBAction)dateAction:(id)sender
{
    [self convertDateToRoman];
}

- (IBAction)shareButton:(id)sender {
    // Show different text for each service, see http://www.albertopasca.it/whiletrue/2012/10/objective-c-custom-uiactivityviewcontroller-icons-text/
    RomanNumsActivityItemProvider *activityItemProvider = [[RomanNumsActivityItemProvider alloc] initWithPlaceholderItem:[_dateLabel text]];
    
    NSArray *itemsToShare = @[activityItemProvider];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    //activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll]; //or whichever you don't need
    [self presentViewController:activityVC animated:YES completion:nil];
}

@end

