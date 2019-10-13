//
//  ViewController.m
//  juecetong
//
//  Created by Ally on 2018/7/21.
//  Copyright © 2018年 Ally. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "JCTWebViewController.h"
#import "WXApi.h"

#define kHomeURL   @"http://47.99.97.17:8084"
//jct.zjol.com.cn:8084


@interface ViewController ()<WKUIDelegate,WKNavigationDelegate,UIWebViewDelegate,WKScriptMessageHandler>
@property (strong, nonatomic) WKWebView *webview;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup {
    [self.view addSubview:self.webview];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kHomeURL]];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"bc" ofType:@"html"]]];
    [self.webview loadRequest:request];
}

- (WKWebView *)webview {
    if (!_webview) {
        CGFloat y = [[UIApplication sharedApplication]statusBarFrame].size.height;
        _webview = [[WKWebView alloc]initWithFrame:CGRectMake(0, y, self.view.bounds.size.width, self.view.bounds.size.height-y)];
        [_webview.configuration.userContentController addScriptMessageHandler:self name:@"sendLinkContent2Friend"];
        [_webview.configuration.userContentController addScriptMessageHandler:self name:@"sendLinkContent2Timeline"];

        _webview.UIDelegate = self;
        _webview.navigationDelegate = self;
    }
    return _webview;
}

// 当点击页面进行加载数据的时候调用
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
// 当页面开始加载的时候调用
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
// 当页面加载完成的时候调用
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}
// 页面加载失败的时候调用
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSLog(@"%@",navigationAction.request.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
}
#pragma mark - WKUIDelegate
 //创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    
    if (!navigationAction.targetFrame.isMainFrame || navigationAction.targetFrame == nil) {
        JCTWebViewController *webVieController= [[JCTWebViewController alloc]init];
        webVieController.request = navigationAction.request;
        [self.navigationController pushViewController:webVieController animated:YES];
    }
    return nil;
}
// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    completionHandler(@"http");
}
// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    completionHandler(YES);
}
// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"%@",message);
    completionHandler();
}

- (void) sendLinkContent2Friend :(NSDictionary *)dic
{
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSString *title = [dic objectForKey:@"title"];
    NSString *description = [dic objectForKey:@"description"];
    NSString *url = [dic objectForKey:@"url"];
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:[UIImage imageNamed:@"logo.png"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = url;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
}

- (void) sendLinkContent2Timeline :(NSDictionary *)dic
{
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSString *title = [dic objectForKey:@"title"];
    NSString *description = [dic objectForKey:@"description"];
    NSString *url = [dic objectForKey:@"url"];
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:[UIImage imageNamed:@"logo.png"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = url;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
}

#pragma mark  WKScriptMessageHandler delegate
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@"%@ - %@", message.name, message.body);
    if ([message.name isEqualToString:@"sendLinkContent2Friend"]) {
        [self sendLinkContent2Friend:message.body];
    } else if ([message.name isEqualToString:@"sendLinkContent2Timeline"]) {
        [self sendLinkContent2Timeline:message.body];
    }
}
@end
