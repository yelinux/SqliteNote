//
//  Student.m
//  SqliteNote
//
//  Created by chenyehong on 2021/6/28.
//

#import "Student.h"

@implementation Student

+(Student*)studentWithID:(NSInteger)ID name:(NSString *)name gender:(NSString *)gender{
    Student *std = [[Student alloc] init];
    std.ID = ID;
    std.name = name;
    std.gender = gender;
    return std;
}

@end
