//
//  FriendTableViewCell.h
//  Funner
//
//  Created by highjump on 14-12-19.
//
//

#import <UIKit/UIKit.h>

@class UserData;

@interface FriendTableViewCell : UITableViewCell

- (void)fillContent:(UserData *)user;

@end
