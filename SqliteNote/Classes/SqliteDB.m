//
//  SqliteDB.m
//  SqliteNote
//
//  Created by chenyehong on 2021/6/28.
//

#import "SqliteDB.h"

static sqlite3 *db = nil;

@implementation SqliteDB

// 打开数据库
+ (sqlite3 *)open {
    // 此方法的主要作用是打开数据库
    // 返回值是一个数据库指针
    // 因为这个数据库在很多的SQLite API（函数）中都会用到，我们声明一个类方法来获取，更加方便

    // 懒加载
    if (db != nil) {
        return db;
    }
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [docPath stringByAppendingPathComponent:@"student.sqlite"];
    
//    // 创建文件管理对象
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    // 判断沙盒路径中是否存在数据库文件，如果不存在才执行拷贝操作，如果存在不在执行拷贝操作
//    if ([fileManager fileExistsAtPath:fileName] == NO) {
//        // 获取数据库文件在包中的路径
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"studentDB" ofType:@"sqlite"];
//        // 使用文件管理对象进行拷贝操作
//        // 第一个参数是拷贝文件的路径
//        // 第二个参数是将拷贝文件进行拷贝的目标路径
//        [fileManager copyItemAtPath:filePath toPath:fileName error:nil];
//    }
    
    // 打开数据库需要使用一下函数
    // 第一个参数是数据库的路径（因为需要的是C语言的字符串，而不是NSString所以必须进行转换）
    // 第二个参数是指向指针的指针
    int result = sqlite3_open([fileName UTF8String], &db);
    if (result == SQLITE_OK) {  // 打开成功
        NSLog(@"成功打开数据库");
    } else {
        NSLog(@"打开数据库失败");
    }
    
    return db;
}

// 关闭数据库
+ (void)close {
    // 关闭数据库
    sqlite3_close(db);
    // 将数据库的指针置空
    db = nil;
}

// 创建表方法
+ (void)createTable {
    
    // 将建表的sql语句放入NSString对象中
    NSString *sql = @"create table if not exists Students (ID integer primary key, name text not null, gender text default '男')";
    
    // 打开数据库
    sqlite3 *db = [SqliteDB open];
    
    // 执行sql语句
    int result = sqlite3_exec(db, sql.UTF8String, nil, nil, nil);
    
    if (result == SQLITE_OK) {
        NSLog(@"建表成功");
    } else {
        NSLog(@"建表失败");
    }
    
    // 关闭数据库
    [SqliteDB close];
}

// 插入一条记录
+ (void)insertStudentWithID:(int)ID name:(NSString *)name gender:(NSString *)gender {
    // 打开数据库
    sqlite3 *db = [SqliteDB open];
    
//    sqlite3_stmt *stmt = nil;
//
//    int result = sqlite3_prepare_v2(db, "insert into Students values(?,?,?)", -1, &stmt, nil);
//
//    if (result == SQLITE_OK) {
//        // 绑定
//        sqlite3_bind_int(stmt, 1, ID);
//        sqlite3_bind_text(stmt, 2, [name UTF8String], -1, nil);
//        sqlite3_bind_text(stmt, 3, [gender UTF8String], -1, nil);
//
//        // 插入与查询不一样，执行结果没有返回值
//        sqlite3_step(stmt);
//    } else {
//        NSLog(@"insert error result = %d", result);
//    }
//    // 释放语句对象
//    sqlite3_finalize(stmt);
    
    // 拼接 sql 语句
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO Students (ID,name,gender) VALUES ('%d','%@','%@');", ID,name,gender];

    // 执行 sql 语句
    char *errMsg = NULL;
    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, &errMsg);

    if (result == SQLITE_OK) {
        NSLog(@"插入数据成功 - %@",name);
    } else {
        NSLog(@"插入数据失败 - %s",errMsg);
    }
}

// 获取表中保存的所有学生
+ (NSArray <Student *>*)allStudents {
    
    // 打开数据库
    sqlite3 *db = [SqliteDB open];
    
    // 创建一个语句对象
    sqlite3_stmt *stmt = nil;
    
    // 声明数组对象
    NSMutableArray <Student *>*mArr = nil;
    
    // 此函数的作用是生成一个语句对象，此时sql语句并没有执行，创建的语句对象，保存了关联的数据库，执行的sql语句，sql语句的长度等信息
    int result = sqlite3_prepare_v2(db, "select * from Students", -1, &stmt, nil);
    if (result == SQLITE_OK) {
        
        // 为数组开辟空间
        mArr = [NSMutableArray arrayWithCapacity:0];
        
        // SQLite_ROW仅用于查询语句，sqlite3_step()函数执行后的结果如果是SQLite_ROW，说明结果集里面还有数据，会自动跳到下一条结果，如果已经是最后一条数据，再次执行sqlite3_step()，会返回SQLite_DONE，结束整个查询
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            // 获取记录中的字段值
            // 第一个参数是语句对象，第二个参数是字段的下标，从0开始
            int ID = sqlite3_column_int(stmt, 0);
            const unsigned char *cName = sqlite3_column_text(stmt, 1);
            const unsigned char *cGender = sqlite3_column_text(stmt, 2);
            
            // 将获取到的C语言字符串转换成OC字符串
            NSString *name = [NSString stringWithUTF8String:(const char *)cName];
            NSString *gender = [NSString stringWithUTF8String:(const char *)cGender];
            Student *student = [Student studentWithID:ID name:name gender:gender];
            
            // 添加学生信息到数组中
            [mArr addObject:student];
        }
    }
    
    // 关闭数据库
    sqlite3_finalize(stmt);
    
    return mArr;
}

// 根据指定的ID，查找相对应的学生
+ (Student *)findStudentByID:(int)ID {
    
    // 打开数据库
    sqlite3 *db = [SqliteDB open];
    
    // 创建一个语句对象
    sqlite3_stmt *stmt = nil;
    
    Student *student = nil;
    
    // 生成语句对象
    int result = sqlite3_prepare_v2(db, "select * from Students where ID = ?", -1, &stmt, nil);
    
    if (result == SQLITE_OK) {
        
        // 如果查询语句或者其他sql语句有条件，在准备语句对象的函数内部，sql语句中用？来代替条件，那么在执行语句之前，一定要绑定
        // 1代表sql语句中的第一个问号，问号的下标是从1开始的
        sqlite3_bind_int(stmt, 1, ID);
        
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            
            // 获取记录中的字段信息
            const unsigned char *cName = sqlite3_column_text(stmt, 1);
            const unsigned char *cGender = sqlite3_column_text(stmt, 2);
            
            // 将C语言字符串转换成OC字符串
            NSString *name = [NSString stringWithUTF8String:(const char *)cName];
            NSString *gender = [NSString stringWithUTF8String:(const char *)cGender];
            
            student = [Student studentWithID:ID name:name gender:gender];
            
        }
    }
    
    // 先释放语句对象
    sqlite3_finalize(stmt);
    return student;
}

// 更新指定ID下的姓名和性别
+ (void)updateStudentName:(NSString *)name gender:(NSString *)gender forID:(int)ID {
    
    // 打开数据库
    sqlite3 *db = [SqliteDB open];
    
    sqlite3_stmt *stmt = nil;
    
    int result = sqlite3_prepare_v2(db, "update Students set name = ?, gender = ? where ID = ?", -1, &stmt, nil);
    if (result == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [name UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 2, [gender UTF8String], -1, nil);
        sqlite3_bind_int(stmt, 3, ID);
        
        sqlite3_step(stmt);
    }
    sqlite3_finalize(stmt);
}

// 根据指定ID删除学生
+ (void)deleteStudentByID:(int)ID {
    
    // 打开数据库
    sqlite3 *db = [SqliteDB open];
    
    sqlite3_stmt *stmt = nil;
    
    int result = sqlite3_prepare_v2(db, "delete from Students where ID = ?", -1, &stmt, nil);
    
    if (result == SQLITE_OK) {
        sqlite3_bind_int(stmt, 1, ID);
        sqlite3_step(stmt);
    }
    
    sqlite3_finalize(stmt);
}

@end
