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

#pragma mark- t_chapter_text

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

#pragma mark- t_chapter_list

// 章节 列表
/*-----------------------------------------  t_chapter_list  ----------------------------------------------------*/
#define kBRDBCreateChapterTable @"CREATE TABLE IF NOT EXISTS t_chapter (\
id INTEGER PRIMARY KEY AUTOINCREMENT,\
book_id TEXT NOT NULL,\
chapter_id TEXT NOT NULL UNIQUE,\
chapter_name TEXT NOT NULL,\
site_id TEXT NOT NULL,\
site_name TEXT,\
time DATETIME NOT NULL\
)"

#define kBRDBInsertChapter(book_id, chapter_id, chapter_name, site_id, site_name, site_url,pre_chapter_id, next_chapter_id, time) @"INSERT OR REPLACE INTO t_chapter (book_id, chapter_id, chapter_name, site_id, site_name, site_url, pre_chapter_id, next_chapter_id, time)\
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", book_id, chapter_id, chapter_name, site_id, site_name, site_url,pre_chapter_id, next_chapter_id, time

#define kBRDBSelectChaptersWithSource_url(source_url) @"SELECT * FROM t_chapter WHERE source_url=?",source_url

#define kBRDBDeleteChapterWithSource_url(source_url) @"DELETE FROM t_chapter WHERE source_url=?",source_url

#define kBRDBSelectAllChapters @"SELECT * FROM t_chapter"

#pragma mark- t_book_info

/*-----------------------------------------  t_book_info  ----------------------------------------------------*/
#define kBRDBCreateBookInfoTabel @"CREATE TABLE IF NOT EXISTS t_book_info(\
id INTEGER PRIMARY KEY AUTOINCREMENT,\
book_name TEXT NOT NULL,\
book_id INTEGER NOT NULL UNIQUE,\
book_cover TEXT,\
author TEXT NOT NULL,\
author_id INTEGER NOT NULL,\
category_id INTEGER NOT NULL,\
category_name TEXT NOT NULL,\
lastupdate_time TEXT NOT NULL,\
book_intro TEXT,\
book_desc TEXT,\
user_select_time DATETIME NOT NULL\
)"

#define kBRDBInsertBookInfo(book_name, book_id, book_cover, author, author_id, category_id, category_name, lastupdate_time ,book_intro , book_desc, user_select_time) @"INSERT OR REPLACE INTO t_book_info (book_name, book_id, book_cover, author, author_id, category_id, category_name, lastupdate_time ,book_intro , book_desc, user_select_time) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",book_name, book_id, book_cover, author, author_id, category_id, category_name, lastupdate_time ,book_intro , book_desc, user_select_time

#define kBRDBSelectBookInfo @"SELECT * FROM t_book_info order by time desc"

#define kBRDBSelectBookInfoWithBookId(book_id) @"SELECT * FROM t_book_info WHERE book_id=?",book_id

#define kBRDBDeleteBookInfo(book_id) @"DELETE FROM t_book_info WHERE book_id=?",book_id

#define kBRDBUpdateBookUserTime(user_select_time, book_id) @"UPDATE t_book_info set user_select_time=? WHERE book_id=?",user_select_time, book_id

#define kBRDBUpdateBookSource(book_id, source_name, book_url) @"UPDATE t_book_info set source_name=?,book_url=? WHERE book_id=?",source_name, book_url, book_id


#pragma mark- t_record
/*-----------------------------------------  t_record  ----------------------------------------------------*/
#define kBRDBCreateRecordTable @"CREATE TABLE IF NOT EXISTS t_record(\
id INTEGER PRIMARY KEY AUTOINCREMENT,\
book_id TEXT NOT NULL UNIQUE,\
chapter_index INTEGER,\
chapter_name TEXT,\
record_text TEXT NOT NULL,\
record_time DATETIME NOT NULL\
)"

#define kBRDBInsertRecord(book_id, chapter_index, record_text, record_time, chapter_name) @"INSERT OR REPLACE INTO t_record (book_id, record_text, chapter_index, record_time, chapter_name) VALUES (?, ?, ?, ?, ?)",book_id, record_text, chapter_index, record_time, chapter_name

#define kBRDBSelectRecordWithBook_id(book_id) @"SELECT * FROM t_record WHERE book_id=? order by id LIMIT 1",book_id

#define kBRDBDeleteRecordWithBook_id(book_id) @"DELETE FROM t_record WHERE book_id=?",book_id

#pragma mark-- t_search_history

/*-----------------------------------------  t_search_history  ----------------------------------------------------*/
#define kBRDBCreateSearchHistoryTabel @"CREATE TABLE IF NOT EXISTS t_search_history(\
id INTEGER PRIMARY KEY AUTOINCREMENT,\
book_name TEXT NOT NULL UNIQUE,\
time DATETIME NOT NULL\
)"

#define kBRDBInsertSearchHistory(book_name, time) @"INSERT OR REPLACE INTO t_search_history (book_name, time) VALUES (?, ?)",book_name, time

#define kBRDBSelectSearchHistory @"SELECT * FROM t_search_history order by time desc"

#define kBRDBDeleteSearchHistoryWithName(book_name) @"DELETE FROM t_search_history WHERE book_name=?",book_name

#define kBRDBDeleteAllHistory @"DELETE FROM t_search_history WHERE book_name IS NOT NULL"


#pragma mark-- record_book
/*-----------------------------------------  record_book  ----------------------------------------------------*/
#define kBRDBSelectBookInfosAndRecord @"SELECT * FROM t_book_info B LEFT OUTER JOIN t_record R ON related_id = R.book_id order by user_select_time desc"


#endif /* BRDatabaseMacros_h */
