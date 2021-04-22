//
//  ViewController.m
//  TODO
//
//  Created by AbdElRahman Nabil on 4/5/21.
//  Copyright © 2021 AbdElRahman Nabil. All rights reserved.
//

#import "ViewController.h"
#import "AddViewController.h"
#import "TodoItem.h"
#import "EditViewController.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *todoTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation ViewController
NSMutableArray *mainArr;
NSMutableArray *todoItems;
NSMutableArray *high;
NSMutableArray *mid;
NSMutableArray *low;
int numOfSections=1;
int numOfRows=0;
NSString *sectionName;
NSMutableArray *filteredArr;
bool filtered=NO;
bool clicked=NO;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    todoItems=[NSMutableArray new];
    /*mainArr=[self readArrayWithCustomObjFromUserDefaults:@"todoItems"];
    for (int i=0;i<[mainArr count];i++) {
        TodoItem *todoInstance=[mainArr objectAtIndex:i];
        if([todoInstance status]==0){
            [todoItems addObject:todoInstance];
        }
    }*/
    self.searchBar.delegate=self;
    self.todoTableView.delegate=self;
    self.todoTableView.dataSource=self;
    [self.todoTableView reloadData];

}
- (IBAction)sortBtn:(id)sender {
    clicked=YES;
    filtered=NO;
    numOfSections=3;
    [_todoTableView reloadData];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    clicked=false;
    numOfSections=1;
    numOfRows=[filteredArr count];
    if (searchText.length==0) {
        filtered=NO;
    }else{
        filtered=YES;
        filteredArr=[NSMutableArray new];
        for (TodoItem *todoTask in todoItems) {
            NSString *title=[todoTask title];
            NSRange titleRange=[title rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (titleRange.location!=NSNotFound) {
                [filteredArr addObject:todoTask];
            }
        }
    }
    [self.todoTableView reloadData];
}
- (IBAction)addBtn:(id)sender {
    AddViewController *addScreen=[self.storyboard instantiateViewControllerWithIdentifier:@"AddViewController"];
    [self.navigationController pushViewController:addScreen animated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return numOfSections;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    TodoItem *todoInstance=[TodoItem new];
    NSMutableArray *currentArr=[NSMutableArray new];
    if (clicked) {
        switch (indexPath.section) {
            case 2:
                currentArr=high;
                break;
            case 1:
                currentArr=mid;
                break;
            case 0:
                currentArr=low;
                break;
            default:currentArr=todoItems;
                break;
        }
    }else{
        currentArr=todoItems;
    }
    if (filtered) {
        currentArr=filteredArr;
    }
    todoInstance=[currentArr objectAtIndex:indexPath.row];
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

- (void)viewDidAppear:(BOOL)animated{
    [todoItems removeAllObjects];
    [self.todoTableView reloadData];
    high=[NSMutableArray new];
    mid=[NSMutableArray new];
    low=[NSMutableArray new];
    mainArr=[self readArrayWithCustomObjFromUserDefaults:@"todoItems"];
    for (NSInteger i=0;i<[mainArr count];i++) {
        TodoItem *todoInstance=[mainArr objectAtIndex:i];
        if([todoInstance status]==0){
            [todoItems addObject:todoInstance];
        }
    }
    for (NSInteger i=0; i<[todoItems count]; i++) {
           TodoItem *todoIns=[todoItems objectAtIndex:i];
           if([todoIns priority]==2){
               [low addObject:todoIns];
           }else if([todoIns priority]==1){
               [mid addObject:todoIns];
           }else if ([todoIns priority]==0){
               [high addObject:todoIns];
           }
       }
    
    [self.todoTableView reloadData];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (clicked) {
        switch (section) {
            case 0:
                numOfRows=[low count];
                break;
            case 1:
                numOfRows=[mid count];
                break;
            case 2:
                numOfRows=[high count];
                break;
            default:numOfRows=0;
                break;
        }
    }
    else{
       numOfRows=[todoItems count];
    }
    if (filtered) {
        numOfRows=[filteredArr count];
    }
    return numOfRows;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (clicked) {
        switch (section) {
            case 0:
                sectionName=@"High";
                break;
            case 1:
                sectionName=@"Mid";
                break;
            default:sectionName=@"Low";
                break;
        }
    }else{
        sectionName=@"";
    }
    return sectionName;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EditViewController *edit=[self.storyboard instantiateViewControllerWithIdentifier:@"EditViewController"];
    TodoItem *selectedItem=[TodoItem new];
    if(clicked){
        switch (indexPath.section) {
            case 0:
                selectedItem=[low objectAtIndex:indexPath.row];
                break;
            case 1:
            selectedItem=[mid objectAtIndex:indexPath.row];
            break;
            case 2:
            selectedItem=[high objectAtIndex:indexPath.row];
            break;
            default:selectedItem=[low objectAtIndex:indexPath.row];
                break;
        }
    }else{
     selectedItem=[todoItems objectAtIndex:indexPath.row];
        
    }
    [edit setTodo:selectedItem];
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
