//
//  MainViewController.h
//  TAlbum
//
//  Created by Liming Tian on 11/18/14.
//  Copyright (c) 2014 Liming Tian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AlbumModel,DetailViewController;
@interface MainViewController : UITableViewController <UIAlertViewDelegate>
{
@private
    NSMutableArray *_albumArr;
}

@property (nonatomic, retain) AlbumModel *editingAlbum;
@property (nonatomic, retain) DetailViewController *detailViewController;
@end
