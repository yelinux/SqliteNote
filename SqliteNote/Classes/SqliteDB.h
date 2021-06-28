//
//  SqliteDB.h
//  SqliteNote
//
//  Created by chenyehong on 2021/6/28.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Student.h"

NS_ASSUME_NONNULL_BEGIN

@interface SqliteDB : NSObject

// 创建表方法
+ (void)createTable;
// 插入一条记录
+ (void)insertStudentWithID:(int)ID name:(NSString *)name gender:(NSString *)gender;
// 获取表中保存的所有学生
+ (NSArray <Student *>*)allStudents;
// 根据指定的ID，查找相对应的学生
+ (Student *)findStudentByID:(int)ID;
// 更新指定ID下的姓名和性别
+ (void)updateStudentName:(NSString *)name gender:(NSString *)gender forID:(int)ID;
// 根据指定ID删除学生
+ (void)deleteStudentByID:(int)ID;

@end

NS_ASSUME_NONNULL_END
