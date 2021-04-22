//
//  DoneViewController.m
//  TODO
//
//  Created by AbdElRahman Nabil on 4/5/21.
//  Copyright © 2021 AbdElRahman Nabil. All rights reserved.
//

#import "DoneViewController.h"
#import "TodoItem.h"
#import "EditViewController.h"
@interface DoneViewController ()
@property (weak, nonatomic) IBOutlet UITableView *doneTableView;

@end

@implementation DoneViewController
NSMutableArray *mainTodoArray;
NSMutableArray *doneItems;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.doneTableView.delegate=self;
    self.doneTableView.dataSource=self;
    
    

    

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)viewDidAppear:(BOOL)animated{
    doneItems=[NSMutableArray new];
    mainTodoArray=[self readArrayWithCustomObjFromUserDefaults:@"todoItems"];
    for (NSInteger i=0;i<[mainTodoArray count];i++) {
        TodoItem *todoInstance=[mainTodoArray objectAtIndex:i];
        if([todoInstance status]==2){
            [doneItems addObject:todoInstance];
        }
    }
    [self.doneTableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    TodoItem *todoInstance=[TodoItem new];
    todoInstance=[doneItems objectAtIndex:indexPath.row];
    cell.textLabel.text=todoInstance.title;
    switch (todoInstance.priority) {
        case 0:
            [cell.imageView setImage:[UIImage imageNamed:@"low.png"]];
            break;
        case 1:
                [cell.imageView setImage:[UIImage imageNamed:@"mid.png"]];
                break;
        case 2:
                [cell.imageView setImage:[UIImage imageNamed:@"high.png"]];
                break;
        default:
            [cell.imageView setImage:[UIImage imageNamed:@"low.png"]];
            break;
    }
    
    return cell;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [doneItems count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *sectionName=@"Done";
    return sectionName;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EditViewController *edit=[self.storyboard instantiateViewControllerWithIdentifier:@"EditViewController"];
    [edit setTodo:[doneItems objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:edit animated:YES];
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
