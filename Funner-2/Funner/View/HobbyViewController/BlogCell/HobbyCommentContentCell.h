//
//  HobbyCommentContentCell.h
//  Funner
//
//  Created by highjump on 15-1-24.
//
//

#import <UIKit/UIKit.h>
#import "BlogCommentContentCell.h"

@interface HobbyCommentContentCell : BlogCommentContentCell

@property (nonatomic) CGFloat mfHeight;

- (NSInteger)fillContent:(BlogData *)data index:(NSInteger)nIndex forHeight:(BOOL)bForHeight;

@end
