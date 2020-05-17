#import <Foundation/Foundation.h>
#import <UIKit/Uikit.h>

@interface AROssClient : NSObject

+ (NSURLSessionUploadTask *)task:(NSString *)filePath
                        fileName:(NSString *)fileName
                ossConfiguration:(NSDictionary *)ossConfiguration
               completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler;

@end
