//
//  AlbumModel.m
//  TAlbum
//
//  Created by Liming Tian on 11/18/14.
//  Copyright (c) 2014 Liming Tian. All rights reserved.
//

#import "AlbumModel.h"

@implementation AlbumModel

#pragma mark - Memory

- (void)dealloc
{
    self.albumName = nil;
    [super dealloc];
}
@end
