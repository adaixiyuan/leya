//
//  BlogLikeCell.m
//  Funner
//
//  Created by highjump on 14-12-3.
//
//

#import "BlogLikeCell.h"
#import "BlogData.h"
#import "NotificationData.h"
#import "CommonUtils.h"
#import "TTTAttributedLabel.h"
#import "UserData.h"

@interface BlogLikeCell()

@property (weak, nonatomic) IBOutlet TTTAttributedLabel *mLblLike;
@property (weak, nonatomic) IBOutlet UIView *mViewBackground;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mCstLblBottom;

@end

@implementation BlogLikeCell

- (void)awakeFromNib {
    // Initialization code
    
    UIColor *colorButton = [UIColor colorWithRed:0/255.0 green:89/255.0 blue:130/255.0 alpha:1.0];
    
    NSMutableDictionary *mutableLinkAttributes = [NSMutableDictionary dictionary];
    [mutableLinkAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    [mutableLinkAttributes setValue:(__bridge id)[colorButton CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
    self.mLblLike.linkAttributes = mutableLinkAttributes;
    
    NSMutableDictionary *mutableActiveLinkAttributes = [NSMutableDictionary dictionaryWithDictionary:mutableLinkAttributes];
    [mutableActiveLinkAttributes setValue:(__bridge id)[[UIColor redColor] CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
    self.mLblLike.activeLinkAttributes = mutableActiveLinkAttributes;
    
    self.mLblLike.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
    
    self.mfHeight = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillContent:(BlogData *)data needConstraint:(BOOL)bNeedConstraint forHeight:(BOOL)bForHeight {
    
    int i = 0;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    //
    // set like text
    //
    NSString *strLike;
    NSMutableString *strLikeTotal = [NSMutableString stringWithString:@""];
    
    for (i = 0; i < MIN([data.maryLikeData count], MAX_SHOW_LIKE_USER_NUM); i++) {
        
        NotificationData *notifyData = [data.maryLikeData objectAtIndex:i];
        
        if (i == MIN([data.maryLikeData count], MAX_SHOW_LIKE_USER_NUM) - 1) {
            strLike = [notifyData.user getUsernameToShow];
        }
        else {
            strLike = [NSString stringWithFormat:@"%@, ", [notifyData.user getUsernameToShow]];
        }
        
        [strLikeTotal appendString:strLike];
    }
    
    if ([data.maryLikeData count] > MAX_SHOW_LIKE_USER_NUM) {
        strLike = [NSString stringWithFormat:@" 等 %ld人", (unsigned long)[data.maryLikeData count]];
        [strLikeTotal appendString:strLike];
    }
    
    strLike = @" 赞过";
    [strLikeTotal appendString:strLike];
    
//    NSLog(@"%f, %f, %f, %f",
//          self.mLblLike.frame.origin.x,
//          self.mLblLike.frame.origin.y,
//          self.mLblLike.frame.size.width,
//          self.mLblLike.frame.size.height);

    if (bForHeight) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat fLabelWidth = screenWidth - 61;
        
        CGSize constrainedSize = CGSizeMake(fLabelWidth, 9999);
        
        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [UIFont systemFontOfSize:13.0], NSFontAttributeName,
                                              nil];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:strLikeTotal attributes:attributesDictionary];
        
        CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        
        self.mfHeight = 1;
        if ([data.maryCommentData count] > 0) {
            self.mfHeight += ceil(requiredHeight.size.height) + 10;
        }
        else {
            self.mfHeight += ceil(requiredHeight.size.height) + 14;
        }

    }
    else {
        //
        // set attributes
        //
        [self.mLblLike setText:strLikeTotal afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            return mutableAttributedString;
        }];
        
        //
        // set links
        //
        strLikeTotal = [NSMutableString stringWithString:@""];
        for (i = 0; i < MIN([data.maryLikeData count], MAX_SHOW_LIKE_USER_NUM); i++) {
            
            NotificationData *notifyData = [data.maryLikeData objectAtIndex:i];
            
            if (i == MIN([data.maryLikeData count], MAX_SHOW_LIKE_USER_NUM) - 1) {
                strLike = [notifyData.user getUsernameToShow];
            }
            else {
                strLike = [NSString stringWithFormat:@"%@, ", [notifyData.user getUsernameToShow]];
            }
            
            dict[@"user"] = notifyData.user;
            [self.mLblLike addLinkToTransitInformation:dict withRange:NSMakeRange(strLikeTotal.length, [strLike length])];
            
            [strLikeTotal appendString:strLike];
        }
        
//        [self layoutIfNeeded];

    }

//    if (bNeedConstraint) {
//        // regulate space
//        if ([data.maryCommentData count] > 0) {
//            [self.mCstLblBottom setConstant:10];
//        }
//        else {
//            [self.mCstLblBottom setConstant:14];
//        }
//        
////        [self setNeedsUpdateConstraints];
//    }
//    
    }

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Make sure the contentView does a layout pass here so that its subviews have their frames set, which we
    // need to use to set the preferredMaxLayoutWidth below.
//    [self.contentView setNeedsLayout];
//    [self.contentView layoutIfNeeded];
    
    
    // Set the preferredMaxLayoutWidth of the mutli-line bodyLabel based on the evaluated width of the label's frame,
    // as this will allow the text to wrap correctly, and as a result allow the label to take on the correct height.
    self.mLblLike.preferredMaxLayoutWidth = CGRectGetWidth(self.mLblLike.frame);
    
//    NSLog(@"%f, %f, %f, %f",
//          self.frame.origin.x,
//          self.frame.origin.y,
//          self.frame.size.width,
//          self.frame.size.height);
}


@end
