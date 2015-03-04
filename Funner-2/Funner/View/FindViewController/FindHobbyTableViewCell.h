//
//  HobbyTableViewCell.h
//  Funner
//
//  Created by highjump on 14-11-25.
//
//

#import <UIKit/UIKit.h>

@class CategoryData;

@interface FindHobbyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mImageView;
@property (weak, nonatomic) IBOutlet UILabel *mLblTitle;
@property (weak, nonatomic) IBOutlet UILabel *mLblDetail;

- (void)showCategoryInfo:(CategoryData *)cData;

@end
