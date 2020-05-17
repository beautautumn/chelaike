#import "AROssClient.h"
#import "AFNetworking.h"

@implementation AROssClient

+ (NSURLSessionUploadTask *)task:(NSString *)filePath
                         fileName:(NSString *)fileName
                  ossConfiguration:(NSDictionary *)ossConfiguration
                 completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler {
    NSDictionary *parameters = @{@"OSSAccessKeyId": ossConfiguration[@"oss_key"],
                                 @"policy": ossConfiguration[@"policy"],
                                 @"Signature": ossConfiguration[@"signature"],
                                 @"success_action_status": @"201",
                                 @"key": fileName};
    NSArray *fileParts = [fileName componentsSeparatedByString:@"/"];
    NSData *fileData = [[NSData alloc] initWithContentsOfFile:filePath];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:ossConfiguration[@"url"] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:fileData name:@"file" fileName:fileParts[[fileParts count] - 1] mimeType:@"image/jpeg"];
    } error:nil];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    return [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:completionHandler];
}

@end
