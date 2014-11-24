//
//  AlbumDB.h
//  TAlbum
//
//  Created by Liming Tian on 11/18/14.
//  Copyright (c) 2014 Liming Tian. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AlbumModel,PictureModel;

@interface AlbumDB : NSObject
+ (NSString *)dataBasePathTest;

+ (void)createAlbumTable;

+ (void)addDataToAlbum:(NSString *)albumName;

+ (void)updateDataToAlbum:(AlbumModel *)albumModel;

+ (void)deleteDataToAlbum:(AlbumModel *)albumModel;

+ (NSMutableArray *)fetchAlbumData;

+ (void)saveAlbum:(AlbumModel *)album;
/////////////////////////////////////////////////////
+ (void)createPictureTable;

+ (void)addDataToPicture:(PictureModel *)picture;

+ (NSMutableArray *)fetchPictureData:(NSInteger)albumid;

+ (NSString *)pictureFilePath:(NSString *)pictureName withAlbum:(NSUInteger)albumid;

+ (void)savePictureData:(NSData *)data withName:(NSString *)pictureName;
@end
