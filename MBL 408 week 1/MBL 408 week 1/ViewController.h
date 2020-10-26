//
//  ViewController.h
//  MBL 408 week 1
//
//  Created by Admin on 4/30/15.
//  Copyright (c) 2015 Adam McCain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "Grades.h"

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *textViewAssignmentName;
@property (strong, nonatomic) IBOutlet UITextField *textViewPointsEarned;
@property (strong, nonatomic) IBOutlet UITextField *textViewPointsPossible;

- (IBAction)addEntryClicked:(id)sender;


@property (strong, nonatomic) IBOutlet UITableView *tableViewGrades;





@end

