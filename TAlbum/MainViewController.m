//
//  MainViewController.m
//  TAlbum
//
//  Created by Liming Tian on 11/18/14.
//  Copyright (c) 2014 Liming Tian. All rights reserved.
//

#import "MainViewController.h"
#import "AlbumDB.h"
#import "AlbumModel.h"
#import "DetailViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

#pragma mark - UITableView Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleBordered target:self action:@selector(addOrEditAlbum)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    [leftBarButtonItem release];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(editAlbum)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    [rightBarButtonItem release];
    
    [self loadAlbums];
    
    AlbumModel *tempAlbumModel = [[AlbumModel alloc] init];
    self.editingAlbum = tempAlbumModel;
    [tempAlbumModel release];
}

#pragma mark - Private Method
- (void)loadAlbums
{
    if (_albumArr == nil) {
        _albumArr = [[NSMutableArray alloc] init];
    } else {
        [_albumArr removeAllObjects];
    }
    _albumArr = [[AlbumDB fetchAlbumData] retain];
}
#pragma mark - Action Method
- (void)addOrEditAlbum
{
    NSString *alertTitle = (self.editingAlbum.albumid != 0) ? @"编辑相册" : @"新建相册";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:@"请输入名称"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"存储", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    if (self.editing) {
        [alertView textFieldAtIndex:0].text = self.editingAlbum.albumName;
    }
    alertView.delegate = self;
    [alertView show];
    [alertView release];
}

- (void)editAlbum
{
    if (!self.editing) {
        self.navigationItem.rightBarButtonItem.title = @"完成";
        self.tableView.allowsSelectionDuringEditing = YES;
        self.editing = YES;
    } else {
        self.navigationItem.rightBarButtonItem.title = @"编辑";
        self.editing = NO;
    }
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (1 == buttonIndex) {
        self.editingAlbum.albumName = [alertView textFieldAtIndex:0].text;
        
        [AlbumDB saveAlbum:self.editingAlbum];
        
        [self loadAlbums];
        [self.tableView reloadData];
    }
    
    self.editingAlbum.albumid = 0;
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_albumArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    AlbumModel *albumModel = _albumArr[indexPath.row];
    cell.textLabel.text = albumModel.albumName;
    
    return cell;
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editing) {
        [self loadAlbums];
        self.editingAlbum = _albumArr[indexPath.row];
        [self addOrEditAlbum];
    } else {
        if (self.detailViewController == nil) {
            self.detailViewController = [[[DetailViewController alloc] init] autorelease];
        }
        self.detailViewController.currentAlbum = _albumArr[indexPath.row];
        [self.navigationController pushViewController:self.detailViewController animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        AlbumModel *deleteAlbum = _albumArr[indexPath.row];
        [AlbumDB deleteDataToAlbum:deleteAlbum];
        [_albumArr removeObject:deleteAlbum];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Memory
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_albumArr release], _albumArr = nil;
    self.editingAlbum = nil;
    self.detailViewController = nil;
    [super dealloc];
}

@end
