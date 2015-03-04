//
//  CommonUtils.h
//  Funner
//
//  Created by highjump on 14-11-4.
//
//

#import <Foundation/Foundation.h>

#define MAX_SHOW_LIKE_USER_NUM 5
#define MAX_SHOW_COMMENT_NUM 6

#define MAX_NEAR_DISTANCE 5.0     //调整附近可见距离

@class CLLocation;
@class UserData;

@interface CommonUtils : NSObject

@property (nonatomic, retain) UIColor *mThemeColor;
@property (nonatomic, retain) UITabBarController *mTabbarController;
@property (nonatomic, retain) NSMutableArray *maryCategory;
@property (retain, nonatomic) CLLocation* mLocationCurrent;

@property (nonatomic, retain) NSMutableArray *maryContact;
@property (nonatomic) CGFloat mfBlogPopularity;

// states
@property (nonatomic) BOOL mbContactReady;

+ (id)sharedObject;

+ (void)makeBlurToolbar:(UIView *)view color:(UIColor *)color;
+ (UIImage*)squareImageFromImage:(UIImage *)image scaledToSize:(CGFloat)newSize;
+ (UIImage*)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+ (UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width;

+ (NSString *)getTimeString:(NSDate *)date;

+ (UserData *)getEmptyUser;

- (void)getContactInfoWithSucess:(void (^)())success;
- (void)addContactUserAsFriend:(NSArray *)contactArray success:(void (^)())success;

@end
