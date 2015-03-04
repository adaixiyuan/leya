//
//  BlogCommentCell.h
//  Funner
//
//  Created by highjump on 14-12-3.
//
//

#import <UIKit/UIKit.h>

@class BlogData;

@interface BlogCommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *mButShowAll;

- (void)fillContent:(BlogData *)data;

@end
