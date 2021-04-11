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
book_id TEXT NOT NULL,\
chapter_id TEXT NOT NULL,\
chapter_name TEXT NOT NULL,\
site_id TEXT NOT NULL,\
site_name TEXT,\
chapter_text TEXT NOT NULL,\
pre_chapter_id TEXT,\
next_chapter_id TEXT,\
time DATETIME NOT NULL)"

#define kBRDBInsertChapterText(book_id, chapter_id, chapter_name, site_id, site_name, chapter_text, pre_chapter_id, next_chapter_id, time) @"INSERT OR REPLACE INTO t_chapter_text (book_id, chapter_id, chapter_name, site_id, site_name, chapter_text,    pre_chapter_id, next_chapter_id, time)\
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", book_id, chapter_id, chapter_name, site_id, site_name, chapter_text, pre_chapter_id, next_chapter_id, time

#define kBRDBSelectChapterTextWithId(chapterId, bookId, siteId) @"SELECT * FROM t_chapter_text WHERE chapter_id=? AND book_id=? AND site_id=? LIMIT 1",chapterId,bookId,siteId

#define kBRDBDeleteChapterTextWithId(chapterId) @"DELETE FROM t_chapter_text WHERE id=?",chapterId

#define kBRDBDeleteChapterTextWithBookId(bookId) @"DELETE FROM t_chapter_text WHERE book_id=?",bookId

#define kBRDBDeleteChapterTextOtherBooks @"SELECT DISTINCT t_chapter_text.book_id FROM t_chapter_text LEFT OUTER JOIN t_book_info ON t_chapter_text.book_id=t_book_info.book_id WHERE t_book_info.book_id is NULL"

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
time TEXT\
)"

#define kBRDBInsertChapter(book_id, chapter_id, chapter_name, site_id, site_name, time) @"INSERT OR REPLACE INTO t_chapter (book_id, chapter_id, chapter_name, site_id, site_name, time)\
VALUES (?, ?, ?, ?, ?, ?)", book_id, chapter_id, chapter_name, site_id, site_name, time

#define kBRDBSelectChaptersWithSiteIdAndBookId(site_id, book_id) @"SELECT * FROM t_chapter WHERE site_id=? AND book_id =?", site_id, book_id
//#define kBRDBSelectChaptersWithSiteIdAndBookId(site_id, book_id) @"SELECT  * FROM t_chapter a left join t_chapter_text b ON a.chapter_id = b.chapter_id AND a.site_id = b.site_id WHERE site_id=? AND book_id =?", site_id, book_id


#define kBRDBDeleteChapterWithSiteIdAndBookId(site_id, book_id) @"DELETE FROM t_chapter WHERE site_id=? AND book_id =? ", source_url, book_id

#define kBRDBSelectAllChapters @"SELECT * FROM t_chapter"

#pragma mark- t_book_info

/*-----------------------------------------  t_book_info  ----------------------------------------------------*/
#define kBRDBCreateBookInfoTabel @"CREATE TABLE IF NOT EXISTS t_book_info(\
id INTEGER PRIMARY KEY AUTOINCREMENT,\
book_name TEXT NOT NULL,\
book_id INTEGER NOT NULL UNIQUE,\
book_cover TEXT,\
author TEXT NOT NULL,\
author_id INTEGER,\
category_id INTEGER NOT NULL,\
category_name TEXT,\
lastupdate_time TEXT,\
lastchapter_name TEXT,\
book_intro TEXT,\
book_desc TEXT,\
sites_text TEXT,\
site_index INTEGER,\
user_select_time DATETIME NOT NULL\
)"

#define kBRDBInsertBookInfo(book_name, book_id, book_cover, author, author_id, category_id, category_name, lastupdate_time ,book_intro , book_desc, lastchapter_name, user_select_time,sites_text, site_index) @"INSERT OR REPLACE INTO t_book_info (book_name, book_id, book_cover, author, author_id, category_id, category_name, lastupdate_time ,book_intro , book_desc, lastchapter_name, user_select_time, sites_text, site_index) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",book_name, book_id, book_cover, author, author_id, category_id, category_name, lastupdate_time ,book_intro , book_desc, lastchapter_name, user_select_time, sites_text,site_index

//#define kBRDBSelectBookInfo @"SELECT * FROM t_book_info LEFT JOIN t_record on t_book_info.book_id=t_record.book_id order by user_select_time desc"

#define kBRDBSelectBookInfo @"SELECT t_book_info.book_name,t_book_info.book_id, t_book_info.book_cover, t_book_info.author, t_book_info.author_id,t_book_info.category_id,t_book_info.category_name,t_book_info.lastupdate_time,t_book_info.lastchapter_name,t_book_info.book_intro,t_book_info.book_desc,t_book_info.sites_text,t_book_info.site_index, t_book_info.user_select_time,t_record.chapter_index,t_record.chapter_name FROM t_book_info LEFT join t_record on t_book_info.book_id=t_record.book_id order by user_select_time desc"

#define kBRDBSelectBookInfoWithBookId(book_id) @"SELECT * FROM t_book_info WHERE book_id=?",book_id

#define kBRDBDeleteBookInfo(book_id) @"DELETE FROM t_book_info WHERE book_id=?",book_id

#define kBRDBUpdateBookUserTime(user_select_time, book_id) @"UPDATE t_book_info set user_select_time=? WHERE book_id=?",user_select_time, book_id

#define kBRDBUpdateBookSource(sites_text, site_index, book_id) @"UPDATE t_book_info set sites_text=?,site_index=? WHERE book_id=?",sites_text, site_index, book_id

#define kBRDBUpdateBookLastChapter(lastchapter_name, lastupdate_time, book_id) @"UPDATE t_book_info set lastchapter_name=?,lastupdate_time=? WHERE book_id=?",lastchapter_name, lastupdate_time, book_id

#define kBRDBUpdateBookInfoAndLastChapter(lastchapter_name, lastupdate_time, book_cover, book_id) @"UPDATE t_book_info set lastchapter_name=?,lastupdate_time=?,book_cover=? WHERE book_id=?", lastchapter_name, lastupdate_time, book_cover, book_id

#pragma mark- t_record
/*-----------------------------------------  t_record  ----------------------------------------------------*/
#define kBRDBCreateRecordTable @"CREATE TABLE IF NOT EXISTS t_record(\
id INTEGER PRIMARY KEY AUTOINCREMENT,\
book_id INTEGER NOT NULL UNIQUE,\
chapter_index INTEGER,\
chapter_name TEXT,\
record_text TEXT NOT NULL,\
record_time DATETIME NOT NULL\
)"

#define kBRDBInsertRecord(book_id, chapter_index, record_text, record_time, chapter_name) @"INSERT OR REPLACE INTO t_record (book_id, chapter_index, record_text, record_time, chapter_name) VALUES (?, ?, ?, ?, ?)",book_id, chapter_index, record_text, record_time, chapter_name

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

#define kBRDBSelectSearchHistory @"SELECT * FROM t_search_history order by time desc limit 8"

#define kBRDBDeleteSearchHistoryWithName(book_name) @"DELETE FROM t_search_history WHERE book_name=?",book_name

#define kBRDBDeleteAllHistory @"DELETE FROM t_search_history WHERE book_name IS NOT NULL"


#pragma mark-- record_book
/*-----------------------------------------  record_book  ----------------------------------------------------*/
#define kBRDBSelectBookInfosAndRecord @"SELECT * FROM t_book_info B LEFT OUTER JOIN t_record R ON related_id = R.book_id order by user_select_time desc"

#pragma mark-- history_book
/*-----------------------------------------  t_historyBook_info  ----------------------------------------------------*/
#define kBRDBCreateHistoryBookInfoTabel @"CREATE TABLE IF NOT EXISTS t_historyBook_info(\
id INTEGER PRIMARY KEY AUTOINCREMENT,\
book_name TEXT NOT NULL,\
book_id INTEGER NOT NULL UNIQUE,\
book_cover TEXT,\
author TEXT NOT NULL,\
author_id INTEGER,\
category_id INTEGER NOT NULL,\
category_name TEXT NOT NULL,\
lastupdate_time TEXT,\
lastchapter_name TEXT,\
book_intro TEXT,\
book_desc TEXT,\
sites_text TEXT,\
site_index INTEGER,\
user_select_time DATETIME NOT NULL\
)"

#define kBRDBInsertHistoryBookInfo(book_name, book_id, book_cover, author, author_id, category_id, category_name, lastupdate_time ,book_intro , book_desc, lastchapter_name, user_select_time,sites_text, site_index) @"INSERT OR REPLACE INTO t_historyBook_info (book_name, book_id, book_cover, author, author_id, category_id, category_name, lastupdate_time ,book_intro , book_desc, lastchapter_name, user_select_time, sites_text, site_index) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",book_name, book_id, book_cover, author, author_id, category_id, category_name, lastupdate_time ,book_intro , book_desc, lastchapter_name, user_select_time, sites_text,site_index

#define kBRDBSelectHistoryBookInfo @"SELECT t_historyBook_info.book_name,t_historyBook_info.book_id, t_historyBook_info.book_cover, t_historyBook_info.author, t_historyBook_info.author_id,t_historyBook_info.category_id,t_historyBook_info.category_name,t_historyBook_info.lastupdate_time,t_historyBook_info.lastchapter_name,t_historyBook_info.book_intro,t_historyBook_info.book_desc,t_historyBook_info.sites_text,t_historyBook_info.site_index, t_record.chapter_index,t_record.chapter_name FROM t_historyBook_info LEFT join t_record on t_historyBook_info.book_id=t_record.book_id order by user_select_time desc"

#define kBRDBDeleteHistoryBooksInfo @"DELETE FROM t_historyBook_info WHERE book_id IS NOT NULL"

#endif /* BRDatabaseMacros_h */
