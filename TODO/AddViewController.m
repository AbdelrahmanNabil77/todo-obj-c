//
//  AddViewController.m
//  TODO
//
//  Created by AbdElRahman Nabil on 4/5/21.
//  Copyright © 2021 AbdElRahman Nabil. All rights reserved.
//

#import "AddViewController.h"
#import "TodoItem.h"
#import "ViewController.h"
@interface AddViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleInput;
@property (weak, nonatomic) IBOutlet UITextField *descInput;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priority;
@property (weak, nonatomic) IBOutlet UISegmentedControl *status;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;



@end

@implementation AddViewController
TodoItem *todo;
NSMutableArray *todoArr;
NSDate *chosenTime;
- (void)viewDidLoad {
    [super viewDidLoad];
    UNUserNotificationCenter *center=[UNUserNotificationCenter currentNotificationCenter];
    UNAuthorizationOptions *options=UNAuthorizationOptionAlert+UNAuthorizationOptionSound;
    // Do any additional setup after loading the view.
    chosenTime=[NSDate new];
    todo=[TodoItem new];
    todoArr=[self readArrayWithCustomObjFromUserDefaults:@"todoItems"];
    if ([todoArr count]==0) {
        todoArr=[NSMutableArray new];
    }
      
    [self setTitle:@"Add"];
        [_datePicker setPreferredDatePickerStyle:UIDatePickerStyleCompact];
    self.datePicker.frame = CGRectMake(0, 0, self.view.frame.size.width, 180.0f); // set frame as your need
    //self.datePicker.datePickerMode = UIDatePickerModeTime;
    
    [self.view addSubview: self.datePicker];
    [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    [self getCurrentDateAndTime];
}

- (void)dateChanged:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *currentTime = [dateFormatter stringFromDate:self.datePicker.date];
    NSLog(@"%@", currentTime);
    chosenTime=self.datePicker.date;
    printf("%d",[chosenTime timeIntervalSinceNow]);
}

-(NSString*)getCurrentDateAndTime{
    NSString *dateAndTime=[NSString new];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    //NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    dateAndTime=[dateFormatter stringFromDate:[NSDate date]];
    printf( [dateAndTime UTF8String]);
    return dateAndTime;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (IBAction)addBtn:(id)sender {
    NSInteger priority=_priority.selectedSegmentIndex;
    int priorityInt=(int)priority;
    NSInteger status=_status.selectedSegmentIndex;
    int statusInt=(int)status;
    switch (priorityInt) {
          case 0:
          [todo setPriority:0];
          break;
              case 1:
              [todo setPriority:1];
              break;
              case 2:
              [todo setPriority:2];
              break;
              
          default:[todo setPriority:0];
              break;
      }
    switch (statusInt) {
        case 0:
        [todo setStatus:0];
        break;
            case 1:
            [todo setStatus:1];
            break;
            case 2:
            [todo setStatus:2];
            break;
            
        default:[todo setStatus:0];
            break;
    }
    [todo setTitle: _titleInput.text];
    [todo setDesc:_descInput.text];
    [todo setCreateDate:[self getCurrentDateAndTime]];
    [todoArr addObject:todo];
    [self writeArrayWithCustomObjToUserDefaults:@"todoItems" withArray:todoArr];
    [self startLocalNotification:chosenTime :_titleInput.text];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)startLocalNotification :(NSDate*) date : (NSString*) title {
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = date;
    notification.alertTitle=title;
    //notification.alertBody = title;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.applicationIconBadgeNumber = 10;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}


-(void)writeArrayWithCustomObjToUserDefaults:(NSString *)keyName withArray:(NSMutableArray *)myArray
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:myArray];
    [defaults setObject:data forKey:keyName];
    [defaults synchronize];
}

-(NSArray *)readArrayWithCustomObjFromUserDefaults:(NSString*)keyName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:keyName];
    NSMutableArray *myArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [defaults synchronize];
    return myArray;
}
@end
