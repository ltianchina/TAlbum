//
//  DetailViewController.h
//  TAlbum
//
//  Created by Liming Tian on 11/19/14.
//  Copyright (c) 2014 Liming Tian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AlbumModel;

@interface DetailViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSMutableArray *_pictureArr;
}
@property (nonatomic, retain) AlbumModel *currentAlbum;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIButton *selectPhotoBtn;
@end
