//
//  EditViewController.m
//  TODO
//
//  Created by AbdElRahman Nabil on 4/5/21.
//  Copyright © 2021 AbdElRahman Nabil. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleView;
@property (weak, nonatomic) IBOutlet UITextField *descView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priority;
@property (weak, nonatomic) IBOutlet UISegmentedControl *status;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *createDate;

@end

@implementation EditViewController
NSMutableArray *todos;
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *deleteBtn=[[UIBarButtonItem alloc]initWithTitle:@"delete" style:UIBarButtonItemStylePlain target:self action:@selector(deleteMethod)];
    [self.navigationItem setRightBarButtonItem:deleteBtn];
    todos=[self readArrayWithCustomObjFromUserDefaults:@"todoItems"];
    NSInteger *priority=0;
    NSInteger *status=0;
    switch (_priority.selectedSegmentIndex) {
        case 0:
            priority=0;
            break;
            case 1:
            priority=1;
            break;
            case 2:
            priority=2;
            break;
        default:
            priority=0;
            break;
    }
    switch (_status.selectedSegmentIndex) {
           case 0:
               status=0;
               break;
               case 1:
               status=1;
               break;
               case 2:
               status=2;
               break;
           default:
            status=0;
               break;
       }
    // Do any additional setup after loading the view.
    _titleView.text=_todo.title;
    _descView.text=_todo.desc;
    _priority.selectedSegmentIndex=priority;
    _status.selectedSegmentIndex=status;
    
    _createDate.text=_todo.createDate;
}
- (IBAction)updateBtn:(id)sender {
    TodoItem *todoItem=[TodoItem new];
    NSInteger priority=_priority.selectedSegmentIndex;
    int priorityInt=(int)priority;
    NSInteger status=_status.selectedSegmentIndex;
    int statusInt=(int)status;
    switch (priorityInt) {
          case 0:
          [todoItem setPriority:0];
          break;
              case 1:
              [todoItem setPriority:1];
              break;
              case 2:
              [todoItem setPriority:2];
              break;
              
          default:[todoItem setPriority:0];
              break;
      }
    switch (statusInt) {
        case 0:
        [todoItem setStatus:0];
        break;
            case 1:
            [todoItem setStatus:1];
            break;
            case 2:
            [todoItem setStatus:2];
            break;
            
        default:[todoItem setStatus:0];
            break;
    }
    [todoItem setTitle:_titleView.text];
    [todoItem setDesc:_descView.text];
    [todoItem setCreateDate:_todo.createDate];
    for (NSInteger i=0;i<[todos count]; i++) {
        TodoItem *tInstance=[todos objectAtIndex:i];
        NSString *date=[tInstance createDate];
        if ([date isEqualToString:[_todo createDate]]) {
            [todos replaceObjectAtIndex:i withObject:todoItem];
        }
    }
    [self writeArrayWithCustomObjToUserDefaults:@"todoItems" withArray:todos];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)deleteMethod{
    
    for (NSInteger i=0;i<[todos count]; i++) {
        TodoItem *tInstance=[todos objectAtIndex:i];
        NSString *date=[tInstance createDate];
        if ([date isEqualToString:[_todo createDate]]) {
            [todos removeObjectAtIndex:i];
        }
    }
    [self writeArrayWithCustomObjToUserDefaults:@"todoItems" withArray:todos];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)writeArrayWithCustomObjToUserDefaults:(NSString *)keyName withArray:(NSMutableArray *)myArray
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:myArray];
    [defaults setObject:data forKey:keyName];
    [defaults synchronize];
}
-(NSMutableArray *)readArrayWithCustomObjFromUserDefaults:(NSString*)keyName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:keyName];
    NSMutableArray *myArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [defaults synchronize];
    return myArray;
}
@end
