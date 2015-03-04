//
//  BlogLikeCell.h
//  Funner
//
//  Created by highjump on 14-12-3.
//
//

#import <UIKit/UIKit.h>

@class BlogData;

@interface BlogLikeCell : UITableViewCell

@property (nonatomic) CGFloat mfHeight;

- (void)fillContent:(BlogData *)data needConstraint:(BOOL)bNeedConstraint forHeight:(BOOL)bForHeight;

@end
