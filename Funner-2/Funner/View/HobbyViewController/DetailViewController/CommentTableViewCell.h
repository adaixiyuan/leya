//
//  CommentTableViewCell.h
//  Funner
//
//  Created by highjump on 14-11-9.
//
//

#import <UIKit/UIKit.h>
#import "BlogCommentContentCell.h"

@class BlogData;

@interface CommentTableViewCell : BlogCommentContentCell

- (void)fillContent:(BlogData *)data index:(NSInteger)nIndex;

@end
