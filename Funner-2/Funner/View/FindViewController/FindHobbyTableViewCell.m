//
//  HobbyTableViewCell.m
//  Funner
//
//  Created by highjump on 14-11-25.
//
//

#import "FindHobbyTableViewCell.h"
#import "CategoryData.h"
#import "UIImageView+WebCache.h"
#import "BlogData.h"
#import "UserData.h"
#import "CommonUtils.h"
#import "ContactData.h"

@interface FindHobbyTableViewCell()

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mConstraintLineHeight;
@property (weak, nonatomic) IBOutlet UIView *mViewRedDot;

@end

@implementation FindHobbyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showCategoryInfo:(CategoryData *)cData {
    
    // show category icon
    NSString *strName = [NSString stringWithFormat:@"%@_icon.png", cData.name];
    UIImage *imgIcon = [UIImage imageNamed:strName];
    
    if (imgIcon) {
        [self.mImageView setImage:imgIcon];
    }
    else {
        [self.mImageView sd_setImageWithURL:[NSURL URLWithString:cData.icon.url]
                           placeholderImage:[UIImage imageNamed:@"home_hobby_sample.png"]];
    }
    
    [self.mLblTitle setText:cData.name];
    [self.mLblDetail setText:@""];

//    [self.mConstraintLineHeight setConstant:0.5];
//    [self layoutIfNeeded];
    
//    if (self.mViewRedDot) {
//        double dRadius = self.mViewRedDot.frame.size.height / 2;
//        [self.mViewRedDot.layer setMasksToBounds:YES];
//        [self.mViewRedDot.layer setCornerRadius:dRadius];
//        
//        [self.mViewRedDot setHidden:YES];
//        
//        if (cData.mbGotLatest && cData.mbGotNetworkLatest) {
//            if (!cData.mBlogLatest && cData.mBlogNetworkLatest) {
//                [self.mViewRedDot setHidden:NO];
//            }
//            else if (cData.mBlogLatest && cData.mBlogNetworkLatest) {
//                if ([cData.mBlogLatest.createdAt compare:cData.mBlogNetworkLatest.createdAt] == NSOrderedAscending) {
//                    [self.mViewRedDot setHidden:NO];
//                }
//            }
//        }
//    }
    
    //
    // friend count
    //
    UserData *currentUser = [UserData currentUser];
    if (!currentUser) {
        currentUser = [CommonUtils getEmptyUser];
    }
    
    NSInteger nCount = 0;
    
    for (UserData *uData in currentUser.maryFriend) {
        if (uData.mnRelation == USERRELATION_FRIEND) {
            // check whether this friend has this category
            if ([uData hasCategory:cData]) {
                nCount++;
            }
        }
    }
    
    if (nCount > 0) {
        [self.mLblDetail setText:[NSString stringWithFormat:@"%ld个朋友", (long)nCount]];
    }
    else {
        [self.mLblDetail setText:@""];
    }
}



@end
