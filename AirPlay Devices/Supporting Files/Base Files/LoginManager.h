//
//  LoginManager.h
//  AirPlay Devices
//
//  Created by Sooraj R on 15/10/24.
//

#import <Foundation/Foundation.h>
#import <FirebaseAuth/FirebaseAuth.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginManager : NSObject

+ (instancetype)sharedInstance;

- (void)signInWithEmail:(NSString *)email
               password:(NSString *)password
            onCompletion:(void (^)(BOOL success, NSString * _Nullable errorMessage))completion;

- (void)checkCurrentUser:(void (^)(BOOL loggedIn, NSString * _Nullable errorMessage))completion;

- (void)forceLogout;

@end

NS_ASSUME_NONNULL_END
