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
chapter_id TEXT NOT NULL,\
book_id TEXT NOT NULL,\
chapter_text TEXT NOT NULL,\
time DATETIME NOT NULL)"

#define kBRDBInsertChapterText(...) @"INSERT INTO t_chapter_text (chapter_id, chapter_text, time, book_id) VALUES (?, ?, ?, ?)",##__VA_ARGS__

#define kBRDBSelectChapterTextWithId(chapterId) @"SELECT * FROM t_chapter_text WHERE chapter_id=? LIMIT 1",chapterId

#define kBRDBDeleteChapterTextWithId(chapterId) @"DELETE FROM t_chapter_text WHERE id=?",chapterId

#define kBRDBDeleteChapterTextWithBookId(bookId) @"DELETE FROM t_chapter_text WHERE book_id=?",book_id

// 章节 列表
/*-----------------------------------------  t_chapter  ----------------------------------------------------*/
#define kBRDBCreateChapterTable @"CREATE TABLE IF NOT EXISTS t_chapter (\
id INTEGER PRIMARY KEY AUTOINCREMENT,\
chapter_name TEXT NOT NULL,\
chapter_id TEXT NOT NULL UNIQUE,\
book_id TEXT NOT NULL,\
site_url TEXT NOT NULL,\
time DATETIME NOT NULL\
)"

#define kBRDBInsertChapter(chapter_name, chapter_url, book_id, chapter_id, source_url, time) @"INSERT OR REPLACE INTO t_chapter (chapter_name, chapter_url, book_id, chapter_id, source_url, time)\
VALUES (?, ?, ?, ?, ?, ?)",chapter_name, chapter_url, book_id, chapter_id, source_url, time

#define kBRDBSelectChaptersWithSource_url(source_url) @"SELECT * FROM t_chapter WHERE source_url=?",source_url

#define kBRDBDeleteChapterWithSource_url(source_url) @"DELETE FROM t_chapter WHERE source_url=?",source_url

#define kBRDBSelectAllChapters @"SELECT * FROM t_chapter"

/*-----------------------------------------  t_book_info  ----------------------------------------------------*/
#define kBRDBCreateBookInfoTabel @"CREATE TABLE IF NOT EXISTS t_book_info(\
id INTEGER PRIMARY KEY AUTOINCREMENT,\
book_name TEXT NOT NULL,\
author TEXT NOT NULL,\
related_id TEXT NOT NULL UNIQUE,\
update_time TEXT NOT NULL,\
book_desc TEXT NOT NULL,\
book_image TEXT,\
book_url TEXT NOT NULL,\
source_name TEXT NOT NULL,\
book_state TEXT NOT NULL,\
book_sort TEXT NOT NULL,\
book_last_chapter TEXT NOT NULL,\
book_word_count INTEGER,\
collection_num INTEGER,\
time DATETIME NOT NULL\
)"

#define kHYDBInsertBookInfo(book_name, author, related_id, update_time, book_desc, book_image, book_url, source_name, book_state, book_sort, book_last_chapter, book_word_count, collection_num, time, user_select_time) @"INSERT OR REPLACE INTO t_book_info (book_name, author, related_id, update_time, book_desc, book_image, book_url, source_name, book_state, book_sort, book_last_chapter, book_word_count, collection_num, time, user_select_time) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",book_name, author, related_id, update_time, book_desc, book_image, book_url, source_name, book_state, book_sort, book_last_chapter, book_word_count, collection_num, time, user_select_time

#define kHYDBSelectBookInfo @"SELECT * FROM t_book_info order by time desc"

#define kHYDBSelectBookInfoWithRelatedId(related_id) @"SELECT * FROM t_book_info WHERE related_id=?",related_id

#define kHYDBDeleteBookInfo(related_id) @"DELETE FROM t_book_info WHERE related_id=?",related_id

#define kHYDBUpdateBookUserTime(user_select_time, related_id) @"UPDATE t_book_info set user_select_time=? WHERE related_id=?",user_select_time, related_id

#define kHYDBUpdateBookSource(related_id, source_name, book_url) @"UPDATE t_book_info set source_name=?,book_url=? WHERE related_id=?",source_name, book_url, related_id


#endif /* BRDatabaseMacros_h */
