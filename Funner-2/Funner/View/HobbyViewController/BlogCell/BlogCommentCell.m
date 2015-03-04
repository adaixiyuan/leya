//
//  BlogCommentCell.m
//  Funner
//
//  Created by highjump on 14-12-3.
//
//

#import "BlogCommentCell.h"
#import "BlogData.h"
#import "CommonUtils.h"
#import "NotificationData.h"
#import "TTTAttributedLabel.h"
#import "UserData.h"

@interface BlogCommentCell()

@end

@implementation BlogCommentCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillContent:(BlogData *)data {

    NSInteger nCount = [data.maryCommentData count];
    NSString *strCaption = [NSString stringWithFormat:@"查看所有%ld条评论", (long)nCount];
    
    [self.mButShowAll setTitle:strCaption forState:UIControlStateNormal];
    
//    
//    NSMutableString *strCommentTotal = [NSMutableString stringWithString:@""];
//    NSString *strComment;
//    
//    BOOL bNeedEllipsis = NO;
//    if ([data.maryCommentData count] > MAX_SHOW_COMMENT_NUM) {
//        bNeedEllipsis = YES;
//    }
//    
//    //
//    // set comment text
//    //
//    for (int i = 0; i < nCount; i++) {
//        NotificationData *notifyData;
//        
//        if (i < 3) {
//            notifyData = [data.maryCommentData objectAtIndex:i];
//        }
//        else {
//            if (bNeedEllipsis) {
//                notifyData = [data.maryCommentData objectAtIndex:[data.maryCommentData count] - nCount + i];
//            }
//            else {
//                notifyData = [data.maryCommentData objectAtIndex:i];
//            }
//        }
//        
//        // username
//        strComment = [notifyData.user getUsernameToShow];
//        
//        [strCommentTotal appendString:strComment];
//        
//        if (i == nCount - 1) {
//            strComment = [NSString stringWithFormat:@" %@", notifyData.comment];
//        }
//        else {
//            strComment = [NSString stringWithFormat:@" %@\n", notifyData.comment];
//        }
//        
//        [strCommentTotal appendString:strComment];
//        
//        if (bNeedEllipsis && i == 2) {
//            strComment = @"... ...\n";
//            [strCommentTotal appendString:strComment];
//        }
//    }
//    
//    if ([data.maryCommentData count] > MAX_SHOW_COMMENT_NUM) {
//        strComment = @"\n\n更多评论";
//        
//        [strCommentTotal appendString:strComment];
//    }
//
//    //
//    // set attributes
//    //
//    [self.mLblComment setText:strCommentTotal afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
////        NSMutableString *strCommentTotal = [NSMutableString stringWithString:@""];
////        NSString *strComment;
////        NSInteger nLastStart = 0;
////        
////        for (int i = 0; i < nCount; i++) {
////            NotificationData *notifyData;
////            
////            if (i < 3) {
////                notifyData = [data.maryCommentData objectAtIndex:i];
////            }
////            else {
////                if (bNeedEllipsis) {
////                    notifyData = [data.maryCommentData objectAtIndex:[data.maryCommentData count] - nCount + i];
////                }
////                else {
////                    notifyData = [data.maryCommentData objectAtIndex:i];
////                }
////            }
////            
////            // username
////            strComment = notifyData.username;
////            
////            if (i == nCount - 1) {
////                nLastStart = [strCommentTotal length];
////            }
////            
////            [strCommentTotal appendString:strComment];
////            
////            if (i == nCount - 1) {
////                strComment = [NSString stringWithFormat:@" %@", notifyData.comment];
////            }
////            else {
////                strComment = [NSString stringWithFormat:@" %@\n", notifyData.comment];
////            }
////            
////            [strCommentTotal appendString:strComment];
////            
////            if (bNeedEllipsis && i == 2) {
////                strComment = @"... ...\n";
////                [strCommentTotal appendString:strComment];
////            }
////        }
////        
////        if ([data.maryCommentData count] > MAX_SHOW_COMMENT_NUM) {
////            strComment = @"\n\n更多评论";
////            
////            NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
////            ps.lineSpacing = 10;
////            
////            NSRange range = NSMakeRange(nLastStart, 1);
////            [mutableAttributedString removeAttribute:(NSString *)kCTParagraphStyleAttributeName range:range];
////            [mutableAttributedString addAttribute:(NSString *)kCTParagraphStyleAttributeName value:ps range:range];
////            
////            [strCommentTotal appendString:strComment];
////        }
////        
//        return mutableAttributedString;
//    }];
//    
//    //
//    // set links
//    //
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//    strCommentTotal = [NSMutableString stringWithString:@""];
//    for (int i = 0; i < nCount; i++) {
//        NotificationData *notifyData;
//        
//        if (i < 3) {
//            notifyData = [data.maryCommentData objectAtIndex:i];
//        }
//        else {
//            if (bNeedEllipsis) {
//                notifyData = [data.maryCommentData objectAtIndex:[data.maryCommentData count] - nCount + i];
//            }
//            else {
//                notifyData = [data.maryCommentData objectAtIndex:i];
//            }
//        }
//        
//        // username
//        strComment = [notifyData.user getUsernameToShow];
//        
//        dict[@"user"] = notifyData.user;
//        [self.mLblComment addLinkToTransitInformation:dict
//                                            withRange:NSMakeRange(strCommentTotal.length, strComment.length)];
//        
//        [strCommentTotal appendString:strComment];
//        
//        if (i == nCount - 1) {
//            strComment = [NSString stringWithFormat:@" %@", notifyData.comment];
//        }
//        else {
//            strComment = [NSString stringWithFormat:@" %@\n", notifyData.comment];
//        }
//        
//        [strCommentTotal appendString:strComment];
//        
//        if (bNeedEllipsis && i == 2) {
//            strComment = @"... ...\n";
//            [strCommentTotal appendString:strComment];
//        }
//    }
//    
//    if ([data.maryCommentData count] > MAX_SHOW_COMMENT_NUM) {
//        strComment = @"\n\n更多评论";
//        
//        dict[@"blog"] = data;
//        [self.mLblComment addLinkToTransitInformation:dict
//                                            withRange:NSMakeRange(strCommentTotal.length, strComment.length)];
//        
//        [strCommentTotal appendString:strComment];
//    }
//
//    [self layoutIfNeeded];
}

@end
