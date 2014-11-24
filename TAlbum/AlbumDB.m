//
//  AlbumDB.m
//  TAlbum
//
//  Created by Liming Tian on 11/18/14.
//  Copyright (c) 2014 Liming Tian. All rights reserved.
//

#import "AlbumDB.h"
#import "FMDatabase.h"
#import "AlbumModel.h"
#import "PictureModel.h"

@implementation AlbumDB

+ (NSString *)dataBasePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = paths[0];
    NSString *dataBasePath = [documentDirectory stringByAppendingPathComponent:@"album.sqlite3"];
    
    return dataBasePath;
}
+ (void)createAlbumTable
{
    FMDatabase *db = [FMDatabase databaseWithPath:[self dataBasePath]];
    
    if ([db open]) {
        NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS ALBUM (albumid INTEGER PRIMARY KEY AUTOINCREMENT, albumname TEXT)";
        BOOL result = [db executeUpdate:sqlCreateTable];
        if (!result) {
            NSLog(@"error when createAlbumTable");
        } else {
            NSLog(@"success when createAlbumTable");
        }
        [db close];
    }
}

+ (void)addDataToAlbum:(NSString *)albumName
{
    FMDatabase *db = [FMDatabase databaseWithPath:[self dataBasePath]];
    
    if ([db open]) {
        NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO ALBUM (albumid,albumName) VALUES (NULL,'%@')",albumName];
        BOOL result = [db executeUpdate:sqlInsert];
        if (!result) {
            NSLog(@"error when addDataToAlbum");
        } else {
            NSLog(@"success when addDataToAlbum");
        }
        [db close];
    }
}

+ (void)updateDataToAlbum:(AlbumModel *)albumModel
{
    FMDatabase *db = [FMDatabase databaseWithPath:[self dataBasePath]];
    
    if ([db open]) {
        NSString *sqlUpdate = [NSString stringWithFormat:@"UPDATE ALBUM SET albumName = '%@' WHERE albumid = %ld",albumModel.albumName,(long)albumModel.albumid];
        BOOL result = [db executeUpdate:sqlUpdate];
        if (!result) {
            NSLog(@"error when sqlUpdate");
        } else {
            NSLog(@"success when sqlUpdate");
        }
        [db close];
    }
}

+ (void)deleteDataToAlbum:(AlbumModel *)albumModel
{
    FMDatabase *db = [FMDatabase databaseWithPath:[self dataBasePath]];
    
    if ([db open]) {
        NSString *sqlDelete = [NSString stringWithFormat:@"DELETE FROM ALBUM WHERE albumid = %ld",(long)albumModel.albumid];
        BOOL result = [db executeUpdate:sqlDelete];
        if (!result) {
            NSLog(@"error when sqlDelete");
        } else {
            NSLog(@"success when sqlDelete");
        }
        [db close];
    }
}

+ (NSMutableArray *)fetchAlbumData
{
    NSMutableArray *albumArr = [[[NSMutableArray alloc] init] autorelease];
    FMDatabase *db = [FMDatabase databaseWithPath:[self dataBasePath]];
    
    if ([db open]) {
        NSString *sqlSelect = @"SELECT * FROM ALBUM";
        FMResultSet *result = [db executeQuery:sqlSelect];
        while ([result next]) {
            AlbumModel *albumModel = [[AlbumModel alloc] init];
            albumModel.albumid = [result intForColumn:@"albumid"];
            albumModel.albumName = [result stringForColumn:@"albumName"];
            [albumArr addObject:albumModel];
            [albumModel release];
        }
    
        [db close];
    }
    return albumArr;
}

+ (void)saveAlbum:(AlbumModel *)album
{
    if (album.albumid == 0) {
        [self addDataToAlbum:album.albumName];
    } else {
        [self updateDataToAlbum:album];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)createPictureTable
{
    FMDatabase *db = [FMDatabase databaseWithPath:[self dataBasePath]];
    
    if ([db open]) {
        NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS PICTURE (pictureid INTEGER PRIMARY KEY AUTOINCREMENT,albumid INTEGER, pictureName TEXT)";
        BOOL result = [db executeUpdate:sqlCreateTable];
        if (!result) {
            NSLog(@"error when createPictureTable");
        } else {
            NSLog(@"success when createPictureTable");
        }
        [db close];
    }
}

+ (void)addDataToPicture:(PictureModel *)picture
{
    FMDatabase *db = [FMDatabase databaseWithPath:[self dataBasePath]];
    
    if ([db open]) {
        NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO PICTURE (pictureid,albumid,pictureName) VALUES (NULL,%d,'%@')",picture.albumid,picture.pictureName];
        BOOL result = [db executeUpdate:sqlInsert];
        if (!result) {
            NSLog(@"error when addDataToPicture");
        } else {
            NSLog(@"success when addDataToPicture");
        }
        [db close];
    }
}

+ (NSMutableArray *)fetchPictureData:(NSInteger)albumid
{
    NSMutableArray *pictureArr = [[[NSMutableArray alloc] init] autorelease];
    FMDatabase *db = [FMDatabase databaseWithPath:[self dataBasePath]];
    
    if ([db open]) {
        NSString *sqlSelect = [NSString stringWithFormat:@"SELECT * FROM PICTURE WHERE albumid = %d",albumid];
        FMResultSet *result = [db executeQuery:sqlSelect];
        while ([result next]) {
            PictureModel *picture = [[PictureModel alloc] init];
            picture.pictureid = [result intForColumn:@"pictureid"];
            picture.albumid = [result intForColumn:@"albumid"];
            picture.pictureName = [result stringForColumn:@"pictureName"];
            [pictureArr addObject:picture];
            [picture release];
        }
        
        [db close];
    }
    return pictureArr;
}

//+ (NSString *)pictureFilePath:(NSString *)pictureName withAlbum:(NSUInteger)albumid
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentDirectory = paths[0];
//    
//    NSString *albumidPath = [NSString stringWithFormat:@"%d",albumid];
//    
//    //NSString *pictureFilePath = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",pictureName]];
//    NSString *pictureFilePath = [[documentDirectory stringByAppendingPathComponent:albumidPath] stringByAppendingPathComponent:pictureName];
//    
//    return pictureFilePath;
//}
//
//+ (void)savePictureData:(NSData *)data withName:(NSString *)pictureName
//{
//    NSFileManager * fileManager = [NSFileManager defaultManager];
//    
//    [fileManager createFileAtPath:pictureName contents:data attributes:nil];
//}
@end
