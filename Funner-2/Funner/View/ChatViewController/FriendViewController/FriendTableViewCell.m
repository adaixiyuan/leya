//
//  FriendTableViewCell.m
//  Funner
//
//  Created by highjump on 14-12-19.
//
//

#import "FriendTableViewCell.h"
#import "UserData.h"
#import "UIImageView+WebCache.h"

@interface FriendTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *mImgViewPhoto;
@property (weak, nonatomic) IBOutlet UILabel *mLblName;
@property (weak, nonatomic) IBOutlet UILabel *mLblFavourite;

@end

@implementation FriendTableViewCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillContent:(UserData *)user {
    
    double dRadius = self.mImgViewPhoto.frame.size.height / 2;
    [self.mImgViewPhoto.layer setMasksToBounds:YES];
    [self.mImgViewPhoto.layer setCornerRadius:dRadius];
    
    [self.mImgViewPhoto sd_setImageWithURL:[NSURL URLWithString:user.photo.url]
                          placeholderImage:[UIImage imageNamed:@"avatar_sample.png"]];
    
    [self.mLblName setText:[user getUsernameToShow]];
    [self.mLblFavourite setText:[user getCategoryString]];
}

@end
