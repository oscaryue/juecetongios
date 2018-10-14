//
//  ViewController.h
//  juecetong
//
//  Created by Ally on 2018/7/21.
//  Copyright © 2018年 Ally. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApiObject.h"

@interface ViewController : UIViewController
- (void) sendLinkContent2Friend : (NSDictionary *)dic;
- (void) sendLinkContent2Timeline : (NSDictionary *)dic;
@end

