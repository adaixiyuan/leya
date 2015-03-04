//
//  CommentTableViewCell.m
//  Funner
//
//  Created by highjump on 14-11-9.
//
//

#import "CommentTableViewCell.h"
#import "BlogData.h"
#import "NotificationData.h"
#import "CommonUtils.h"
#import "UserData.h"

#import "UIButton+WebCache.h"

@interface CommentTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *mViewLine;
@property (weak, nonatomic) IBOutlet UILabel *mLblUsername;
@property (weak, nonatomic) IBOutlet UILabel *mLblDate;

@end


@implementation CommentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillContent:(BlogData *)data index:(NSInteger)nIndex {
    
    [super fillContent:data index:nIndex];
    
    if (nIndex == 0) {
        [self.mViewLine setHidden:YES];
    }
    else {
        [self.mViewLine setHidden:NO];
    }
    
    NotificationData *notifyData = [data.maryCommentData objectAtIndex:nIndex];
    [self.mLblUsername setText:notifyData.username];
    
    if (notifyData.createdAt) {
        // date
        [self.mLblDate setText:[CommonUtils getTimeString:notifyData.createdAt]];
    }
    else {
        [self.mLblDate setText:[CommonUtils getTimeString:data.createdAt]];
    }
}


@end
