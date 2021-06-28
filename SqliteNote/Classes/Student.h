//
//  Student.h
//  SqliteNote
//
//  Created by chenyehong on 2021/6/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Student : NSObject

@property (assign, nonatomic) NSInteger ID;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *gender;

+(Student*)studentWithID:(NSInteger)ID name:(NSString *)name gender:(NSString *)gender;

@end

NS_ASSUME_NONNULL_END
