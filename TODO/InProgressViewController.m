//
//  InProgressViewController.m
//  TODO
//
//  Created by AbdElRahman Nabil on 4/5/21.
//  Copyright © 2021 AbdElRahman Nabil. All rights reserved.
//

#import "InProgressViewController.h"
#import "TodoItem.h"
#import "EditViewController.h"

@interface InProgressViewController ()
@property (weak, nonatomic) IBOutlet UITableView *inProgressTableView;

@end

@implementation InProgressViewController
NSMutableArray *mainArray;
NSMutableArray *inProgressItems;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.inProgressTableView.delegate=self;
    self.inProgressTableView.dataSource=self;
    
    

    

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
    inProgressItems=[NSMutableArray new];
    mainArray=[self readArrayWithCustomObjFromUserDefaults:@"todoItems"];
    for (NSInteger i=0;i<[mainArray count];i++) {
        TodoItem *todoInstance=[mainArray objectAtIndex:i];
        if([todoInstance status]==1){
            [inProgressItems addObject:todoInstance];
        }
    }
    [self.inProgressTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    TodoItem *todoInstance=[TodoItem new];
    todoInstance=[inProgressItems objectAtIndex:indexPath.row];
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
    return [inProgressItems count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *sectionName=@"In progress";
    return sectionName;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EditViewController *edit=[self.storyboard instantiateViewControllerWithIdentifier:@"EditViewController"];
    [edit setTodo:[inProgressItems objectAtIndex:indexPath.row]];
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
