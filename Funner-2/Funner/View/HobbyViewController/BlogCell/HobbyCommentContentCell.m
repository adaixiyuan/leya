//
//  HobbyCommentContentCell.m
//  Funner
//
//  Created by highjump on 15-1-24.
//
//

#import "HobbyCommentContentCell.h"
#import "BlogData.h"
#import "CommonUtils.h"
#import "NotificationData.h"

@interface HobbyCommentContentCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mCstLblBottom;

@end

@implementation HobbyCommentContentCell

- (void)awakeFromNib {
    // Initialization code
    
    self.mfHeight = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSInteger)fillContent:(BlogData *)data index:(NSInteger)nIndex forHeight:(BOOL)bForHeight {
    
    NSInteger nCommentIndex = nIndex;
    
    if ([data.maryCommentData count] > MAX_SHOW_COMMENT_NUM) {
        if (nIndex > 2) {
            nCommentIndex = [data.maryCommentData count] - (MAX_SHOW_COMMENT_NUM - nIndex);
        }
    }
    
    [super fillContent:data index:nCommentIndex];
    
    // get comment text for getting size
    NotificationData *notifyData = [data.maryCommentData objectAtIndex:nCommentIndex];
    NSString *strComment = notifyData.comment;
    
    if ([data.maryCommentData count] > MAX_SHOW_COMMENT_NUM) {
        if (nIndex == 2) {
            strComment = [NSString stringWithFormat:@"%@\n... ...", self.mLblComment.text];
            [self.mLblComment setText:strComment];
        }
    }
    
    if (bForHeight) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat fLabelWidth = screenWidth - 93;
        
        CGSize constrainedSize = CGSizeMake(fLabelWidth, 9999);
        
        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [UIFont systemFontOfSize:13.0], NSFontAttributeName,
                                              nil];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:strComment attributes:attributesDictionary];
        
        CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        
        self.mfHeight = 6;
        if (nIndex == MIN([data.maryCommentData count], MAX_SHOW_COMMENT_NUM) - 1) {
            self.mfHeight += ceil(requiredHeight.size.height) + 16;
        }
        else {
            self.mfHeight += ceil(requiredHeight.size.height) + 8;
        }
    }
//    else {
//        if (nIndex == MIN([data.maryCommentData count], MAX_SHOW_COMMENT_NUM) - 1) {
//            [self.mCstLblBottom setConstant:16];
//        }
//        else {
//            [self.mCstLblBottom setConstant:8];
//        }
//        
//        [self layoutIfNeeded];
//    }
    
    
    return nCommentIndex;
}

@end
