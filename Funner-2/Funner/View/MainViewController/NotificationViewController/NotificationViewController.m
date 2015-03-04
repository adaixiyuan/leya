//
//  NotificationViewController.m
//  Funner
//
//  Created by highjump on 14-11-8.
//
//

#import "NotificationViewController.h"
#import "NotificationTableViewCell.h"
#import "NotificationData.h"
#import "DetailViewController.h"
#import "CommonUtils.h"

#import <AVOSCloud/AVOSCloud.h>

typedef enum {
    NOTIFY_NEW = 0,
    NOTIFY_ALL
} NotifyShowType;


@interface NotificationViewController () {
    NotificationData *mCurNotify;
    NotifyShowType mnShowType;
}

@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@end

@implementation NotificationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    mnShowType = NOTIFY_NEW;
    
    [self showRightMenu];
    
    UIEdgeInsets edgeTable = self.mTableView.contentInset;
    edgeTable.top = 64;
    [self.mTableView setContentInset:edgeTable];
    
    [self.mTableView scrollRectToVisible:CGRectMake(0, 0, 320, 1) animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    // get new notification count
    NSInteger nCount = 0;
    for (NotificationData *notifyData in self.maryNotification) {
        if ([notifyData.isnew boolValue]) {
            nCount++;
        }
    }
    if (nCount == 0) {
        mnShowType = NOTIFY_ALL;
    }
    
    [self.mTableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    if (mCurNotify && [mCurNotify.isnew boolValue]) {
        mCurNotify.isnew = [NSNumber numberWithBool:NO];
        [mCurNotify saveInBackground];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"Notify2Detail"]) {
        DetailViewController *viewController = [segue destinationViewController];
        viewController.mBlogData = mCurNotify.blog;
        viewController.mNotificationData = mCurNotify;
    }
}



#pragma mark - TableView

- (NSInteger)getRowCount {
    NSInteger nCount = 0;
    
    if (mnShowType == NOTIFY_NEW) {
        for (NotificationData *notifyData in self.maryNotification) {
            if ([notifyData.isnew boolValue]) {
                nCount++;
            }
        }
        
        if (nCount < [self.maryNotification count]) {
            nCount++; // show more cell
        }
    }
    else {
        nCount = [self.maryNotification count];
    }
    
    return nCount;
}

- (NSInteger)getOldCount {
    NSInteger nCount = 0;
    
    for (NotificationData *notifyData in self.maryNotification) {
        if (![notifyData.isnew boolValue]) {
            nCount++;
        }
    }
    
    return nCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self getRowCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    if (mnShowType == NOTIFY_NEW) {
        NotificationTableViewCell *notifyCell = (NotificationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"NotificationCellID"];
        NSInteger nCount = 0;
        
        for (NotificationData *notifyData in self.maryNotification) {
            if ([notifyData.isnew boolValue]) {
                if (nCount == indexPath.row) {
                    [notifyCell fillContent:notifyData];
                    cell = notifyCell;
                    break;
                }
                nCount++;
            }
        }
        
        if (!cell && [self getOldCount] > 0) {
            // show more cell
            cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationMoreCellID"];
        }
    }
    else {
        NotificationTableViewCell *notifyCell = (NotificationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"NotificationCellID"];
        NotificationData *notifyData = [self.maryNotification objectAtIndex:indexPath.row];
        [notifyCell fillContent:notifyData];
        
        cell = notifyCell;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat fHeight = 210;
    
    if (mnShowType == NOTIFY_NEW) {
        
        if ([self getOldCount] > 0 && [self getRowCount] == indexPath.row + 1) {
            fHeight = 40;
        }

    }
    
    return fHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (mnShowType == NOTIFY_NEW) {
        NSInteger nCount = 0;
        mCurNotify = nil;
        
        for (NotificationData *notifyData in self.maryNotification) {
            if ([notifyData.isnew boolValue]) {
                if (nCount == indexPath.row) {
                    mCurNotify = notifyData;
                    [self gotoNotifyDetail];
                    break;
                }
                nCount++;
            }
        }

        if (!mCurNotify) {
            if ([self getOldCount] > 0 && [self getRowCount] == indexPath.row + 1) {
                mnShowType = NOTIFY_ALL;
                [self.mTableView reloadData];
            }
        }
    }
    else {
        mCurNotify = [self.maryNotification objectAtIndex:indexPath.row];
        if ([mCurNotify.isnew boolValue]) {
            [self gotoNotifyDetail];
        }
    }
}

- (void)gotoNotifyDetail {
    [self performSegueWithIdentifier:@"Notify2Detail" sender:nil];
}

- (void)showRightMenu {
    UIBarButtonItem *rightButton = nil;
    
    // check if the current category is mine
    if ([self.maryNotification count] > 0) {
        rightButton = [[UIBarButtonItem alloc] initWithTitle:@"清空"
                                                       style:UIBarButtonItemStyleBordered
                                                      target:self
                                                      action:@selector(onButClear:)];
        
        [self.mTableView setHidden:NO];
    }
    else {
        [self.mTableView setHidden:YES];
    }
    
    [self.navigationItem setRightBarButtonItem:rightButton];
}

- (IBAction)onButClear:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@""
                                                   message:@"您确定要删除所有的消息吗？"
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"删除",nil];
    [alert show];
}

#pragma mark - Alert Delegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        for (NotificationData *notifyData in self.maryNotification) {
            notifyData[@"isread"] = [NSNumber numberWithBool:YES];
            [notifyData saveInBackground];
        }
        [self.maryNotification removeAllObjects];
        
        [self showRightMenu];
        
        mnShowType = NOTIFY_ALL;
        [self.mTableView reloadData];
    }
}


@end
