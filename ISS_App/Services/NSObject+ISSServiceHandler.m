//
//  NSObject+ISSServiceHandler.m
//  ISS_App
//
//  Created by Malkhasyan, Georgi on 8/8/22.
//

#import "NSObject+ISSServiceHandler.h"
#import "ISS_App-Swift.h"

@implementation NSObject (ISSServiceHandler)
- (void)fetchSpaceStationPosition:(void(^)(NSString* latitude, NSString* longitude))completed {
    NSString *urlString = @"http://api.open-notify.org/iss-now.json";
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"Finished fetching position...");
        
        dispatch_async( dispatch_get_main_queue(),
        ^{
            // parse returned JSON array
            NSError *err;
            NSDictionary *positionJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
            
            if (err) {
                NSLog(@"Failed to serialize into JSON: %@", err);
            } else {
                NSLog( @"%@", positionJSON );
                
                NSDictionary* issPosition = [positionJSON objectForKey:@"iss_position"];
                NSString * latitude = [issPosition objectForKey:@"latitude"];
                NSString * longitude = [issPosition objectForKey:@"longitude"];
                
                completed(latitude, longitude);
            }
        } );
        
    }] resume];
}
@end
