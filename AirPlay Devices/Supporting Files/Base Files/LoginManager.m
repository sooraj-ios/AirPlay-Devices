//
//  LoginManager.m
//  AirPlay Devices
//
//  Created by Sooraj R on 15/10/24.
//

#import <Foundation/Foundation.h>
#import "LoginManager.h"

@implementation LoginManager : NSObject 

+ (instancetype)sharedInstance {
    static LoginManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LoginManager alloc] init];
    });
    return sharedInstance;
}

- (void)signInWithEmail:(NSString *)email password:(NSString *)password onCompletion:(void (^)(BOOL, NSString * _Nullable))completion {
    [[FIRAuth auth] signInWithEmail:email password:password completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
        if (error) {
            completion(NO, error.localizedDescription);
        } else {
            if (authResult.user) {
                [authResult.user getIDTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
                    if (token) {
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        [defaults setBool:YES forKey:@"isLoggedIn"];
                        [defaults setObject:email forKey:@"userEmail"];
                        [defaults setObject:token forKey:@"user_token"];
                        [defaults synchronize];
                        completion(YES, nil);
                    }
                }];
            }
        }
    }];
}

- (void)checkCurrentUser:(void (^)(BOOL, NSString * _Nullable))completion {
    FIRUser *currentUser = [[FIRAuth auth] currentUser];

    if (currentUser) {
        [currentUser getIDTokenResultWithCompletion:^(FIRAuthTokenResult * _Nullable tokenResult, NSError * _Nullable error) {
            if (error || !tokenResult.token) {
                [self forceLogout];
                completion(NO, @"Logged out due to token error or invalid token.");
            } else {
                // Optionally check the expiration date or other token properties
                if (tokenResult.expirationDate && [tokenResult.expirationDate compare:[NSDate date]] == NSOrderedDescending) {
                    completion(YES, nil);  // Token is valid
                } else {
                    [self forceLogout];
                    completion(NO, @"Token has expired. Logged out.");
                }
            }
        }];
    } else {
        completion(NO, @"No user logged in.");
    }
}

- (void)forceLogout {
    NSError *signOutError;
    BOOL status = [[FIRAuth auth] signOut:&signOutError];
}

@end
