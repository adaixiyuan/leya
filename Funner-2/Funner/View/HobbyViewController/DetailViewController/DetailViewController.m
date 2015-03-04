//
//  DetailViewController.m
//  Funner
//
//  Created by highjump on 14-11-9.
//
//

#import "DetailViewController.h"
#import "CommentTableViewCell.h"
#import "BlogData.h"
#import "BlogContentCell.h"
#import "BlogLikeCell.h"
#import "CommonUtils.h"
#import "NotificationData.h"
#import "TTTAttributedLabel.h"
#import "MeViewController.h"
#import "CustomActionSheetView.h"
#import "UserData.h"


@interface DetailViewController () </*BlogRelationCellDelegate, */CustomActionSheetDelegate, BlogContentDelegate> {
    UserData *mUserSelected;
    UIColor *mColorNormal;
    UIColor *mColorDisable;
    
    CustomActionSheetView *mActionsheetViewDelete;
//    CustomActionSheetView *mActionsheetViewReport;
    
    BOOL mbKeyboardOn;
}

@property (weak, nonatomic) IBOutlet UIView *mViewText;
@property (weak, nonatomic) IBOutlet UITextField *mTxtComment;
@property (weak, nonatomic) IBOutlet UIButton *mButSend;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@property (weak, nonatomic) IBOutlet UIView *mViewNotice;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mConstraintNoticeBottom;

@property (weak, nonatomic) IBOutlet UIView *mViewComment;

@end

@implementation DetailViewController

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
    
//    [self.mViewText.layer setMasksToBounds:YES];
//    [self.mViewText.layer setCornerRadius:5];
//    
//    self.mViewText.layer.borderColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1].CGColor;
//    self.mViewText.layer.borderWidth = 1.0f;
//    
//    [self.mButSend.layer setMasksToBounds:YES];
//    [self.mButSend.layer setCornerRadius:5];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShow:)
												 name:UIKeyboardWillShowNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification
											   object:nil];
    
    self.mTableView.estimatedRowHeight = UITableViewAutomaticDimension;
    
//    mColorNormal = [UIColor colorWithRed:36/255.0 green:185/255.0 blue:191/255.0 alpha:1];
//    mColorDisable = [UIColor grayColor];
//    
//    [self.mButSend setBackgroundColor:mColorNormal];
    
    if (!self.mBlogData.user) { // not fetched
        [self.mBlogData fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
            [self getLikeComment];
        }];
    }
    else {
        [self getLikeComment];
    }
    
    
//
//    mActionsheetViewReport = (CustomActionSheetView *)[CustomActionSheetView initView:self.view
//                                                                         ButtonTitle1:@""
//                                                                         ButtonTitle2:@""
//                                                                         ButtonTitle3:@"举报这张图片"];
//    mActionsheetViewReport.delegate = self;
    
//    // Center horizontally
//    [mActionsheetViewReport addConstraint:[NSLayoutConstraint constraintWithItem:mActionsheetViewReport
//                                                     attribute:NSLayoutAttributeBottom
//                                                     relatedBy:NSLayoutRelationEqual
//                                                        toItem:self.view
//                                                     attribute:NSLayoutAttributeBottom
//                                                    multiplier:1.0
//                                                      constant:0.0]];
//    
//    [mActionsheetViewReport addConstraint:[NSLayoutConstraint constraintWithItem:mActionsheetViewReport
//                                                     attribute:NSLayoutAttributeLeading
//                                                     relatedBy:NSLayoutRelationEqual
//                                                        toItem:self.view
//                                                     attribute:NSLayoutAttributeLeading
//                                                    multiplier:1.0
//                                                      constant:0.0]];
//    
//    [mActionsheetViewReport addConstraint:[NSLayoutConstraint constraintWithItem:mActionsheetViewReport
//                                                     attribute:NSLayoutAttributeTrailing
//                                                     relatedBy:NSLayoutRelationEqual
//                                                        toItem:self.view
//                                                     attribute:NSLayoutAttributeTrailing
//                                                    multiplier:1.0
//                                                      constant:0.0]];

    
    UIEdgeInsets edgeTable = self.mTableView.contentInset;
    edgeTable.top = 64;
    edgeTable.bottom = self.mViewComment.frame.size.height;
    [self.mTableView setContentInset:edgeTable];
    
    [self.mViewNotice setAlpha:0];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:tap];
    
    mbKeyboardOn = NO;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
}


-(void)dismissKeyboard:(UITapGestureRecognizer *) sender {
    [self.view endEditing:YES];
}

- (void)getLikeComment {
    UIBarButtonItem *rightButton = nil;
    
//    if ([self.mBlogData.user.objectId isEqualToString:[UserData currentUser].objectId]) {
        rightButton = [[UIBarButtonItem alloc] initWithTitle:@"更多"
                                                       style:UIBarButtonItemStyleBordered
                                                      target:self
                                                      action:@selector(onButRightItem:)];
        [self.navigationItem setRightBarButtonItem:rightButton];
//    }
    
    if (self.mBlogData.mbGotLike && self.mBlogData.mbGotComment) {
        [self performSelector:@selector(scrollToComment) withObject:nil afterDelay:0.1];
    }
    else {
        [self.mBlogData fillBlogData:NO afterSuccess:^(){
            if (self.mBlogData.mbGotLike && self.mBlogData.mbGotComment) {
                [self.mTableView reloadData];
                [self performSelector:@selector(scrollToComment) withObject:nil afterDelay:0.1];
            }
        }];
    }
}

- (void)scrollToComment {
    if (!self.mNotificationData) {
        return;
    }
    
    if (self.mNotificationData.type == NOTIFICATION_COMMENT) {
        // get comment index
        NSInteger nIndex = 0;
        for (nIndex = 0; nIndex < [self.mBlogData.maryCommentData count]; nIndex++) {
            NotificationData *nData = [self.mBlogData.maryCommentData objectAtIndex:nIndex];
            if ([nData.objectId isEqualToString:self.mNotificationData.objectId]) {
                break;
            }
        }
        
        nIndex += 1;
        
        if ([self.mBlogData.maryLikeData count] > 0) {
            nIndex++;
        }
        
        nIndex = MIN(nIndex, [self.mTableView numberOfRowsInSection:0] - 1);
        
        [self.mBlogData.maryCommentData indexOfObject:self.mNotificationData];
        
        [self.mTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:nIndex inSection:0]
                               atScrollPosition:UITableViewScrollPositionBottom
                                       animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"Detail2Me"]) {
        MeViewController *viewController =  [segue destinationViewController];
        viewController.mUser = mUserSelected;
    }
}


- (IBAction)onButBack:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)onButRightItem:(id)sender {
    
    if (mbKeyboardOn) {
        return;
    }
    
//    if (!mActionsheetViewDelete) {
        mActionsheetViewDelete = (CustomActionSheetView *)[CustomActionSheetView initView:self.view
                                                                             ButtonTitle1:@""
                                                                             ButtonTitle2:@""
                                                                             ButtonTitle3:@"删除图片"
                                                                           removeOnCancel:YES];
        mActionsheetViewDelete.delegate = self;
//    }
    
    CGRect rtFrame = mActionsheetViewDelete.frame;
    rtFrame.size.height = 155;
    [mActionsheetViewDelete setFrame:rtFrame];
    
    if ([self.mBlogData.user.objectId isEqualToString:[UserData currentUser].objectId]) {
        [mActionsheetViewDelete setThirdTitle:@"删除图片"];
    }
    else {
        [mActionsheetViewDelete setThirdTitle:@"举报这张图片"];
    }
    
    
    if (![mActionsheetViewDelete isShowing]) {
        [mActionsheetViewDelete showView];
    }
}

#pragma mark - CustomActionSheetDelegate

- (void)onButThird:(UIView *)view {
    if ([self.mBlogData.user.objectId isEqualToString:[UserData currentUser].objectId]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@""
                                                       message:@"您确定要删除这个图片吗？"
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"删除",nil];
        [alert show];
    }
    else {
        // 举报照片
        NSLog(@"举报picture");
        int originalCount = [[self.mBlogData objectForKey:@"report_count"] intValue];
        originalCount += 1;
        [self.mBlogData setObject: [NSNumber numberWithInt:originalCount] forKey:@"report_count"];
        [self.mBlogData saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                UIAlertView *alert  = [[UIAlertView alloc]initWithTitle:@""
                                                                message:@"举报成功!"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
        }];
    }
}

#pragma mark - Alert Delegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        // delete blog object
        [self.mBlogData deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                for (NotificationData *notifyData in self.mBlogData.maryLikeData) {
                    [notifyData deleteInBackground];
                }
                for (NotificationData *notifyData in self.mBlogData.maryCommentData) {
                    [notifyData deleteInBackground];
                }
                
                if (self.delegate) {
                    [self.delegate deleteBlog:self.mBlogData];
                }
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            else {
                // show notice
                [self showNotice];
            }
        }];
    }
}


#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger nCount = 1;
    
    if ([self.mBlogData.maryLikeData count]) {
        nCount++;
    }
    nCount += [self.mBlogData.maryCommentData count];
    
    return nCount;
}

- (UITableViewCell *)configureCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath forHeight:(BOOL)bForHeight {
    UITableViewCell *cell;
    
    if (indexPath.row == 0) {
        BlogContentCell *contentCell = (BlogContentCell *)[tableView dequeueReusableCellWithIdentifier:@"BlogContentCellID"];
        
        [contentCell fillContent:self.mBlogData forHeight:bForHeight];
        
        if (!bForHeight) {
//            [contentCell showHashTag:NO];
//            [contentCell splashHashTag];
            
            [contentCell.mButPhoto addTarget:self action:@selector(onButUser:) forControlEvents:UIControlEventTouchUpInside];
            [contentCell.mButName addTarget:self action:@selector(onButUser:) forControlEvents:UIControlEventTouchUpInside];
            
            contentCell.mContentDelegate = self;
        }
    
        cell = contentCell;
    }
    else if (indexPath.row == 1) {
        if ([self.mBlogData.maryLikeData count] > 0) {
            BlogLikeCell *likeCell = (BlogLikeCell *)[tableView dequeueReusableCellWithIdentifier:@"BlogLikeCellID"];
            [likeCell fillContent:self.mBlogData needConstraint:NO forHeight:NO];
            
            cell = likeCell;
        }
        else {
            cell = [self configureCommentCell:tableView index:indexPath.row - 1];
        }
    }
    else {
        if ([self.mBlogData.maryLikeData count] > 0) {
            cell = [self configureCommentCell:tableView index:indexPath.row - 2];
        }
        else {
            cell = [self configureCommentCell:tableView index:indexPath.row - 1];
        }
        
    }
    
    return cell;
}

- (CommentTableViewCell *)configureCommentCell:(UITableView *)tableView index:(NSInteger)nIndex {
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCommentCellID"];
    
    [cell fillContent:self.mBlogData index:nIndex];
    
    return cell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self configureCell:tableView cellForRowAtIndexPath:indexPath forHeight:NO];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    CGFloat height = 0;
    
//    switch (indexPath.row) {
//        case 0: {
//            // BlogContentCellID
//            height = 378;
//            break;
//        }
//            
//        default:
            cell = [self configureCell:tableView cellForRowAtIndexPath:indexPath forHeight:YES];
//            break;
//    }
    
    if (cell) {
//        [cell setNeedsUpdateConstraints];
//        [cell updateConstraintsIfNeeded];
//        
//        cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
//        
//        [cell setNeedsLayout];
//        [cell layoutIfNeeded];
        
        height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    }
    
    return height;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self.view endEditing:YES];
//}


- (void)animationView:(CGFloat)yPos {
    
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait)
    { //phone
        
        CGSize sz = [[UIScreen mainScreen] bounds].size;
        if(yPos == sz.height - self.view.frame.size.height)
            return;
        
//        self.view.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.3
                         animations:^{
                             CGRect rt = self.view.frame;
                             rt.size.height = sz.height - yPos;
//                             NSLog(@"animationview: %f", rt.size.height);
                             self.view.frame = rt;
                             
                             [self.view layoutIfNeeded];
                         }completion:^(BOOL finished) {
//                             self.view.userInteractionEnabled = YES;
                         }];
    }
}

#pragma mark - KeyBoard notifications
- (void)keyboardWillShow:(NSNotification*)notify {
	CGRect rtKeyBoard = [(NSValue*)[notify.userInfo valueForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait) {
        [self animationView:rtKeyBoard.size.width];
    }
    else {
        [self animationView:rtKeyBoard.size.height];
    }
    
    mbKeyboardOn = YES;
}

- (void)keyboardWillHide:(NSNotification*)notify {
	[self animationView:0];
    
    mbKeyboardOn = NO;
}

# pragma mark - TextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    [self onButSend:nil];
    
    return YES;
}


- (IBAction)onButSend:(id)sender {
    
    if (sender) {
        [self.view endEditing:YES];
    }
    
    if ([self.mTxtComment.text length] == 0) {
        return;
    }
    
    NSString *strComment = [self.mTxtComment.text substringToIndex:MIN(self.mTxtComment.text.length, 100)];
    
    //
    // save to notification database
    //
    NotificationData *notifyObj = [NotificationData object];
    notifyObj.blog = self.mBlogData;
    notifyObj.user = [UserData currentUser];
    notifyObj.username = [[UserData currentUser] getUsernameToShow];
    notifyObj[@"targetuser"] = self.mBlogData.user;
    notifyObj.thumbnail = self.mBlogData.image;
    notifyObj.type = NOTIFICATION_COMMENT;
    notifyObj.comment = strComment;
    notifyObj.isnew = [NSNumber numberWithBool:YES];
    notifyObj[@"isread"] = @(NO);
    
    [notifyObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        [self.mButSend setBackgroundColor:mColorNormal];
        
        if (succeeded) {
            //
            // add comment object
            //
            [self.mBlogData.maryCommentData addObject:notifyObj];
            AVRelation *relation = self.mBlogData.commentobject;
            [relation addObject:notifyObj];
            
            // set popularity
            [self.mBlogData incrementKey:@"likecomment"];
            [self.mBlogData calculatePopularity];
            
            [self.mBlogData saveInBackground];
            
            [self.mTableView reloadData];
            
            [self.mTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.mBlogData.maryCommentData.count inSection:0]
                                   atScrollPosition:UITableViewScrollPositionTop
                                           animated:YES];
            
            [self.mButSend setEnabled:YES];
        }
        else {
            [self showNotice];
        }
    }];
    
//    [self.mButSend setBackgroundColor:mColorDisable];
    
    [self.mTxtComment setText:@""];
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    NSInteger rows = [self.mTableView numberOfRowsInSection:0];
    
    if (rows > 0) {
        [self.mTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                               atScrollPosition:UITableViewScrollPositionBottom
                                       animated:animated];
    }
}

- (void)onButUser:(id)sender {
    mUserSelected = self.mBlogData.user;
    [self gotoMeView];
}

- (void)gotoMeView {
    if ([mUserSelected.objectId isEqualToString:[UserData currentUser].objectId]) {
        return;
    }
    
    [self performSegueWithIdentifier:@"Detail2Me" sender:nil];
}

#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label
didSelectLinkWithTransitInformation:(NSDictionary *)components {
    
    mUserSelected = components[@"user"];
    [self gotoMeView];
}

#pragma mark - BlogRelationCellDelegate
- (void)onLikeResult:(BOOL)bResult {
    if (bResult) {
        [self.mTableView reloadData];
    }
    else {
        [self showNotice];
    }
}

#pragma mark - BlogContentCellDelegate
- (void)touchedTagView {
    [self dismissKeyboard:nil];
}


- (void)showNotice {
    // show notice
    [UIView animateWithDuration:0.5
                     animations:^{
                         [self.mConstraintNoticeBottom setConstant:-self.mViewNotice.frame.size.height];
                         [self.mViewNotice setAlpha:1];
                         [self.view layoutIfNeeded];
                         
                     }completion:^(BOOL finished) {
                         [self performSelector:@selector(hideNotice) withObject:nil afterDelay:2.0];
                     }];
}
- (void)hideNotice {
    [UIView animateWithDuration:0.5
                     animations:^{
                         [self.mConstraintNoticeBottom setConstant:0];
                         [self.mViewNotice setAlpha:0];
                         [self.view layoutIfNeeded];
                     }completion:^(BOOL finished) {
                         //						 self.view.userInteractionEnabled = YES;
                     }];
}



@end
