//
//  DescriptionViewController.m
//  BeiLu
//
//  Created by YKJ2 on 16/4/19.
//  Copyright © 2016年 YKJ1. All rights reserved.
//

#import "DescriptionViewController.h"
#import "UILabel+DynamicSize.h"
#import <WebKit/WebKit.h>

@interface DescriptionViewController ()<WKNavigationDelegate>
@property (strong, nonatomic) WKWebView *webView;

@end

@implementation DescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.isHourly isEqualToString:@"YES"]){
        self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-158-60)];
    }else{
        self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-158)];
    }
    
    self.webView.navigationDelegate = self;
    self.webView.backgroundColor = [UIColor whiteColor];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.preferences = [[WKPreferences alloc] init];
    config.preferences.minimumFontSize = 30;
    
    
    [self.view addSubview:self.webView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MBPromptView showLoadingView:self.view];
    NSMutableString *html = [NSMutableString stringWithString:@"<html>"];
    [html appendString:@"<head>"];
    [html appendString:@"<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">"];
//    [html appendString:@"<style> body { font-size: 100%; } </style>"];
    [html appendString:@"</head>"];
    [html appendString:@"<body>"];
    [html appendString:[self deleteHref:self.descStr]];
    [html appendString:@"</body>"];
    [html appendString:@"</html>"];
    
    
    [self.webView loadHTMLString:html baseURL:nil];
    
}
- (NSString *)deleteHref:(NSString *)string {
    NSError *regexError = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<a href=.*?>(.*?)</a>" options:NSRegularExpressionCaseInsensitive error:&regexError];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@"$1"];
    return modifiedString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [MBPromptView hideLoadingView];

    [self.webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';" completionHandler:nil];
    [self.webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    [MBPromptView hideLoadingView];
}

@end
