//
//  JCTWebViewController.h
//  juecetong
//
//  Created by Ally on 2018/8/23.
//  Copyright © 2018年 Ally. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApiObject.h"

@interface JCTWebViewController : UIViewController
- (void) sendLinkContent2Friend : (NSString*)title : (NSString*)description : (NSString*)url;
@property (nonatomic, strong) NSURLRequest *request;

@end
