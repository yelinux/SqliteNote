//
//  ViewController.m
//  SqliteNote
//
//  Created by chenyehong on 2021/6/28.
//

#import "ViewController.h"
#import "SqliteDB.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //创建表
//    [SqliteDB createTable];
    //插入一条数据
//    [SqliteDB insertStudentWithID:167 name:@"国产零零漆" gender:@"男"];
//    [SqliteDB insertStudentWithID:169 name:@"李兰香" gender:@"女"];
    //更新指定ID的数据
//    [SqliteDB updateStudentName:@"国产007" gender:@"男" forID:167];
    //删除记录
//    [SqliteDB deleteStudentByID:167];
    //查询表里的所有数据
    NSArray <Student *>* arr = [SqliteDB allStudents];
    [arr enumerateObjectsUsingBlock:^(Student * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%ld, %@, %@", obj.ID, obj.name, obj.gender);
    }];
    // 根据指定的ID，查找指定数据
//    Student *obj = [SqliteDB findStudentByID:167];
//    NSLog(@"%ld, %@, %@", obj.ID, obj.name, obj.gender);
}


@end
