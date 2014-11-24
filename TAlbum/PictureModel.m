//
//  PictureModel.m
//  TAlbum
//
//  Created by Liming Tian on 11/18/14.
//  Copyright (c) 2014 Liming Tian. All rights reserved.
//

#import "PictureModel.h"

@implementation PictureModel

#pragma mark - Memory

- (void)dealloc
{
    [self.pictureName release];
    [super dealloc];
}
@end
