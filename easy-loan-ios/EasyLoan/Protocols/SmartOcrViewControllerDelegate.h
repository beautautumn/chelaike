#import <UIKit/UIKit.h>

@protocol SmartOcrViewControllerDelegate <NSObject>

- (void)onScanVin:(NSString *)vin imgagePath:(NSString *)imgagePath;

@end
