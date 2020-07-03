//
//  BRDataBaseManager.m
//  bookReader
//
//  Created by Jobs on 2020/6/29.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRDataBaseManager.h"
#import "BRDatabaseMacros.h"
#import <FMDB/FMDB.h>


@interface BRDataBaseManager()

@property(nonatomic, strong) FMDatabaseQueue *databaseQueue;
@property(nonatomic, strong) FMDatabase *database;

@end


@implementation BRDataBaseManager

+ (instancetype)sharedInstance{
    static BRDataBaseManager *dataBase;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataBase = [[BRDataBaseManager alloc] init];
    });
    return dataBase;
}

- (instancetype)initDataBase {
    self = [super init];
    if (self) {
        self.database = [FMDatabase databaseWithPath:kBRDatabasePath];
        self.databaseQueue = [FMDatabaseQueue databaseQueueWithPath:kBRDatabasePath];
        if ([self.database open]) {
            
        }
    }
    
    return self;
}


@end
