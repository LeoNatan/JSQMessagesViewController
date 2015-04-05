//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import "JSQMessagesTimestampFormatter.h"

@interface JSQMessagesTimestampFormatter ()

@property (strong, nonatomic, readwrite) NSDateFormatter *timeFormatter;
@property (strong, nonatomic, readwrite) NSDateFormatter *relativeDateFormatter;
@property (strong, nonatomic, readwrite) NSDateFormatter *timestampFormatter;

@end



@implementation JSQMessagesTimestampFormatter

#pragma mark - Initialization

+ (JSQMessagesTimestampFormatter *)sharedFormatter
{
    static JSQMessagesTimestampFormatter *_sharedFormatter = nil;
    
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        _sharedFormatter = [[JSQMessagesTimestampFormatter alloc] init];
    });
    
    return _sharedFormatter;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.timeFormatter = [[NSDateFormatter alloc] init];
        [self.timeFormatter setLocale:[NSLocale currentLocale]];
        [self.timeFormatter setDoesRelativeDateFormatting:YES];
		[self.timeFormatter setDateStyle:NSDateFormatterNoStyle];
		[self.timeFormatter setTimeStyle:NSDateFormatterShortStyle];
		
		self.relativeDateFormatter = [[NSDateFormatter alloc] init];
		[self.relativeDateFormatter setLocale:[NSLocale currentLocale]];
		[self.relativeDateFormatter setDoesRelativeDateFormatting:YES];
		[self.relativeDateFormatter setDateStyle:NSDateFormatterMediumStyle];
		[self.relativeDateFormatter setTimeStyle:NSDateFormatterNoStyle];
		
		self.timestampFormatter = [[NSDateFormatter alloc] init];
		[self.timestampFormatter setLocale:[NSLocale currentLocale]];
		[self.timestampFormatter setDoesRelativeDateFormatting:YES];
		[self.timestampFormatter setDateStyle:NSDateFormatterMediumStyle];
		[self.timestampFormatter setTimeStyle:NSDateFormatterShortStyle];
		
        UIColor *color = [UIColor lightGrayColor];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        
        _dateTextAttributes = @{ NSFontAttributeName : [UIFont boldSystemFontOfSize:12.0f],
                                 NSForegroundColorAttributeName : color,
                                 NSParagraphStyleAttributeName : paragraphStyle };
        
        _timeTextAttributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:12.0f],
                                 NSForegroundColorAttributeName : color,
                                 NSParagraphStyleAttributeName : paragraphStyle };
    }
    return self;
}

#pragma mark - Formatter

- (NSString *)timestampForDate:(NSDate *)date
{
    if (!date) {
        return nil;
    }
	
	return [self.timestampFormatter stringFromDate:date];
}

- (NSAttributedString *)attributedTimestampForDate:(NSDate *)date
{
    if (!date) {
        return nil;
    }
    
    NSString *relativeDate = [self relativeDateForDate:date];
    NSString *time = [self timeForDate:date];
    
    NSMutableAttributedString *timestamp = [[NSMutableAttributedString alloc] initWithString:relativeDate
                                                                                  attributes:self.dateTextAttributes];
    
    [timestamp appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    
    [timestamp appendAttributedString:[[NSAttributedString alloc] initWithString:time
                                                                      attributes:self.timeTextAttributes]];
    
    return [[NSAttributedString alloc] initWithAttributedString:timestamp];
}

- (NSString *)timeForDate:(NSDate *)date
{
    if (!date) {
        return nil;
    }
	
    return [self.timeFormatter stringFromDate:date];
}

- (NSString *)relativeDateForDate:(NSDate *)date
{
    if (!date) {
        return nil;
    }
	
    return [self.relativeDateFormatter stringFromDate:date];
}

@end
