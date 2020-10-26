//
//  ViewController.m
//  MBL 408 week 1
//
//  Created by Admin on 4/30/15.
//  Copyright (c) 2015 Adam McCain. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSMutableArray *gradesArray;
    sqlite3 *gradesDatabase;
    NSString *databasePath;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    gradesArray = [[NSMutableArray alloc] init];
    [[self tableViewGrades]setDelegate:self];
    [[self tableViewGrades]setDataSource:self];
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *myPath = [path objectAtIndex:0];
    
    databasePath = [myPath stringByAppendingPathComponent:@"grades.db"];
    
    char * error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:databasePath]) {
        const char *gradesDatabasePath = [databasePath UTF8String];
        
        if (sqlite3_open(gradesDatabasePath, &gradesDatabase)==SQLITE_OK) {
            const char *sql_statement = "CREATE TABLE IF NOT EXISTS grades (ID INTEGER PRIMARY KEY AUTOINCREMENT, ASSIGNMENTNAME TEXT, POINTSPOSSIBLE INTEGER, POINTSEARNED INTEGER)";
            sqlite3_exec(gradesDatabase, sql_statement, NULL, NULL, &error);
            sqlite3_close(gradesDatabase);
        }
    }

    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [gradesArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"myCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    Grades *grade = [gradesArray objectAtIndex:indexPath.row];
    cell.textLabel.text = grade.assignmentName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d / %d", grade.pointsEarned, grade.pointsPossible];
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addEntryClicked:(id)sender {
  
    char * error;
    
    if(sqlite3_open([databasePath UTF8String], &gradesDatabase)==SQLITE_OK) {
        NSString *insertStatement = [NSString stringWithFormat:@"INSERT INTO grades(ASSIGNMENTNAME,POINTSPOSSIBLE,POINTSEARNED) values('%s', '%d', '%d')",[self.textViewAssignmentName.text UTF8String], [self.textViewPointsPossible.text intValue], [self.textViewPointsEarned.text intValue]];
    
        const char *insert_Statement = [insertStatement UTF8String];

        NSLog(@"got this far...");
        
        if (sqlite3_exec(gradesDatabase, insert_Statement, NULL, NULL, &error)==SQLITE_OK) {
            NSLog(@"Assignment added");
            
            Grades *grade = [[Grades alloc] init];
            [grade setAssignmentName:self.textViewAssignmentName.text];
            [grade setPointsPossible:[self.textViewPointsPossible.text intValue]];
            [grade setPointsEarned:[self.textViewPointsEarned.text intValue]];
            
            [gradesArray addObject:grade];
        }
        sqlite3_close(gradesDatabase);
        [[self tableViewGrades] reloadData];
    }
    else {
        NSLog(@"not working");
    }
    
}

- (IBAction)viewGradesClicked:(id)sender {
    
    sqlite3_stmt *statement;
    
    if(sqlite3_open([databasePath UTF8String], &gradesDatabase)==SQLITE_OK) {
        [gradesArray removeAllObjects];
        
        NSString * queryDatabase = [NSString stringWithFormat:@"SELECT * FROM grades"];
        const char *query_database = [queryDatabase UTF8String];
        
        if (sqlite3_prepare(gradesDatabase, query_database, -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                NSString *assignmentName = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(statement, 1)];
                NSString *pointsPossible = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 2)];
                NSString *pointsEarned = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, 3)];
                
                Grades *grades = [[Grades alloc] init];
                
                [grades setAssignmentName:assignmentName];
                [grades setPointsPossible:[pointsPossible intValue]];
                [grades setPointsEarned:[pointsEarned intValue]];
                
                [gradesArray addObject:grades];
            }
        }
    }
    [[self tableViewGrades] reloadData];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [[self textViewAssignmentName] resignFirstResponder];
    [[self textViewPointsPossible] resignFirstResponder];
    [[self textViewPointsEarned] resignFirstResponder];
}

- (IBAction)deleteEntryClicked:(id)sender {

    [[self tableViewGrades] setEditing:!self.tableViewGrades.editing animated:YES];


}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        
        Grades *grades = [gradesArray objectAtIndex:indexPath.row];
        [self deleteEntry:[NSString stringWithFormat:@"DELETE FROM grades WHERE ASSIGNMENTNAME IS '%s'", [grades.assignmentName UTF8String]]];
        [gradesArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}

-(void)deleteEntry:(NSString *)deleteQuery {
    char *error;
    
    if(sqlite3_exec(gradesDatabase, [deleteQuery UTF8String], NULL, NULL, &error)==SQLITE_OK) {
    
    }
}


@end
