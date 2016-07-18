//
//  WebViewController.m
//  BeiLu
//
//  Created by YKJ2 on 16/5/12.
//  Copyright © 2016年 YKJ1. All rights reserved.
//

#import "WebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>


@protocol TestJSExport <JSExport>
//JSExportAs
//(calculateForJS  /** handleFactorialCalculateWithNumber 作为js方法的别名 */,
// - (void)handleFactorialCalculateWithNumber:(NSNumber *)number
// );
- (void)pushViewControllerTitle:(NSString *)title;

//-(void)log:(NSString*)l;

@end

@interface WebViewController ()<UIWebViewDelegate,TestJSExport>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) JSContext *context;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MBPromptView showLoading];
    if (self.isFirst) {
        [self getHtmlUrl];
    }
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:self.path ofType:@"html"];
//    NSURL *url = [NSURL URLWithString:path];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    
    NSString *imagname;
    NSUserDefaults *ssd = [NSUserDefaults standardUserDefaults];
    NSNumber *logoshow = [ssd objectForKey:@"LogoShow"];
    if ([logoshow integerValue] == 1){
        imagname = @"logo21";
    }else{
        imagname = @"logo2";
    }
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imagname]];
    self.navigationItem.titleView = imageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBPromptView hideLoading];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    // 打印异常
    self.context.exceptionHandler =
    ^(JSContext *context, JSValue *exceptionValue)
    {
        context.exception = exceptionValue;
        NSLog(@"%@", exceptionValue);
    };
    // 以 JSExport 协议关联 native 的方法
    self.context[@"app"] = self;
}

- (void)pushViewControllerTitle:(NSString *)title {
    dispatch_async(dispatch_get_main_queue(), ^{
        WebViewController *webVC = [[WebViewController alloc] init];
        webVC.path = @"help";
        [self.navigationController pushViewController:webVC animated:YES];
    });
}

- (void)getHtmlUrl{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    //用户id
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *customer_id = [defaults objectForKey:@"Userid"];
    NSString *token=[defaults objectForKey:@"Token"];
 
    if (0==customer_id.length || 0==token){
        [parameters setObject:@"" forKey:@"customer_id"];//未登录或是游客时
        [parameters setObject:@"" forKey:@"token"];
    }else{
        [parameters setObject:customer_id forKey:@"customer_id"];
        
        [parameters setObject:token forKey:@"token"];
    }
    
    [parameters setObject:[MainViewManager languageStye] forKey:@"languages"];
    [parameters setObject:@"customersupport" forKey:@"req"];
    
    
    //    NSMutableDictionary *postParameter = [NSMutableDictionary dictionary];
    //    NSString *Pstring = [parameters mj_JSONString];
    //    [postParameter setObject:Pstring forKey:@"handler"];
    
//    NSLog(@"postParameter is %@", parameters);
    [[NetworkSingleton sharedManager] postCWDataResult:parameters url:kAPPHANDLER_URL successBlock:^(id responseBody){
//        NSLog(@"获取数据成功 is %@", responseBody);
        [MBPromptView hideLoading];
        
        if (responseBody != nil){
            NSNumber *status = [responseBody objectForKey:@"status"];
            NSNumber *s= [NSNumber numberWithInt:1];
            if ([status isEqualToNumber:s]){
                NSDictionary *sDic = [responseBody objectForKey:@"data"];
                NSString *str = sDic[@"support_url"];
                [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                
            }else {
                NSString *message = [responseBody objectForKey:@"message"];
                if (message != nil){
                    [ZXZPromptView failWithDetail:message];
                }
            }
        }else {
            [ZXZPromptView failWithTitle:ZDLocalizedString(@"TxNE", nil) detail:ZDLocalizedString(@"TxNCF", nil)];
        }
        
    } failureBlock:^(NSString *error){
        [MBPromptView hideLoading];
        [ZXZPromptView failWithTitle:ZDLocalizedString(@"TxNE", nil) detail:ZDLocalizedString(@"TxNCF", nil)];
        
    }];
}

@end
