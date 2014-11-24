//
//  PictureModel.h
//  TAlbum
//
//  Created by Liming Tian on 11/18/14.
//  Copyright (c) 2014 Liming Tian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PictureModel : NSObject

@property (nonatomic, assign) NSInteger pictureid;
@property (nonatomic, assign) NSInteger albumid;
@property (nonatomic, retain) NSString *pictureName;
@end
