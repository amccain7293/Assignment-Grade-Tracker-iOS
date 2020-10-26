//
//  Grades.h
//  MBL 408 week 1
//
//  Created by Admin on 5/4/15.
//  Copyright (c) 2015 Adam McCain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Grades : UIButton

@property(nonatomic, strong)NSString *assignmentName;
@property(assign)int pointsPossible;
@property(assign)int pointsEarned;

@end
