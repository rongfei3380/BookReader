//
//  BRDatabaseMacros.h
//  bookReader
//
//  Created by Jobs on 2020/6/29.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#ifndef BRDatabaseMacros_h
#define BRDatabaseMacros_h

#define kBRDatabaseName @"BRDatabase.sqlite"
#define kBRDatabasePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:kBRDatabaseName]

// 章节内容表        
/*-----------------------------------------  t_chapter_text  ----------------------------------------------------*/
#define kBRDBCreateChapterTextTable @"CREATE TABLE IF NOT EXISTS t_chapter_text (\
id INTEGER PRIMARY KEY AUTOINCREMENT,\
chapter_url TEXT NOT NULL,\
book_id TEXT NOT NULL,\
chapter_text TEXT NOT NULL,\
time DATETIME NOT NULL)"

#endif /* BRDatabaseMacros_h */
