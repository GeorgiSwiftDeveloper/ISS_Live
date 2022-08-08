//
//  NSObject+ISSServiceHandler.h
//  ISS_App
//
//  Created by Malkhasyan, Georgi on 8/8/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ISSServiceHandler)
-(void)fetchSpaceStationPosition:(void(^)(NSString* latitude, NSString* longitude))completed;
@end

NS_ASSUME_NONNULL_END
