//
//  DetailViewController.m
//  TAlbum
//
//  Created by Liming Tian on 11/19/14.
//  Copyright (c) 2014 Liming Tian. All rights reserved.
//

#import "DetailViewController.h"
#import "AlbumModel.h"
#import "PictureModel.h"
#import "AlbumDB.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
#pragma mark - UIView lifecycle
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(changeTitle)];
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStylePlain] autorelease];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.selectPhotoBtn = [[[UIButton alloc] initWithFrame:CGRectMake(0, 440, 320, 40)] autorelease];
    [self.selectPhotoBtn setTitle:@"从系统相册复制照片" forState:UIControlStateNormal];
    [self.selectPhotoBtn addTarget:self action:@selector(copyPictureFromLibrary) forControlEvents:UIControlEventTouchUpInside];
    self.selectPhotoBtn.hidden = YES;
    self.selectPhotoBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.selectPhotoBtn];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = self.currentAlbum.albumName;
}

#pragma mark - Private Method
- (void)loadPictures
{
    if (_pictureArr == nil) {
        _pictureArr = [[NSMutableArray alloc] init];
    } else {
        [_pictureArr removeAllObjects];
    }
    
    _pictureArr = [[AlbumDB fetchPictureData:self.currentAlbum.albumid] retain];
}
#pragma mark - Action
- (void)changeTitle
{
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"编辑"]) {
        self.navigationItem.rightBarButtonItem.title = @"完成";
        self.selectPhotoBtn.hidden = NO;
    } else {
        self.navigationItem.rightBarButtonItem.title = @"编辑";
        self.selectPhotoBtn.hidden = YES;
    }
}

- (void)copyPictureFromLibrary
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSString *pictureName = [NSString stringWithFormat:@"%u",arc4random()%1000];
    NSString *name = [AlbumDB pictureFilePath:pictureName withAlbum:self.currentAlbum.albumid];
    [AlbumDB savePictureData:UIImageJPEGRepresentation(image, 1.0) withName:name];

    PictureModel *picture = [[PictureModel alloc] init];
    picture.pictureName = pictureName;
    picture.albumid = self.currentAlbum.albumid;

    [AlbumDB addDataToPicture:picture];
    [picture release];
    [self loadPictures];
    [self.tableView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_pictureArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    PictureModel *picture = _pictureArr[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:picture.pictureName];
    
    return cell;
}

#pragma mark - Memory
- (void)dealloc
{
    self.currentAlbum = nil;
    [super dealloc];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
