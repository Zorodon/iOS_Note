//
//  RichTextViewController.m
//  BeiLu
//
//  Created by YKJ2 on 16/5/26.
//  Copyright © 2016年 YKJ1. All rights reserved.
//

#import "RichTextViewController.h"

@interface RichTextViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *richTextView;

@end

@implementation RichTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MBPromptView showLoading];
    [self getRichText];
    
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
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", webView.frame.size.width];
    [webView stringByEvaluatingJavaScriptFromString:meta];
    //
    [self.richTextView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [self.richTextView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    [MBPromptView hideLoading];
}

- (void)getRichText{
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
    [parameters setObject:self.reqUrl forKey:@"req"];
    
    
    //    NSMutableDictionary *postParameter = [NSMutableDictionary dictionary];
    //    NSString *Pstring = [parameters mj_JSONString];
    //    [postParameter setObject:Pstring forKey:@"handler"];
    
//         NSLog(@"postParameter is %@", parameters);
    [[NetworkSingleton sharedManager] postCWDataResult:parameters url:kAPPHANDLER_URL successBlock:^(id responseBody){
//                NSLog(@"获取数据成功 is %@", responseBody);
        [MBPromptView hideLoading];

        if (responseBody != nil){
            NSNumber *status = [responseBody objectForKey:@"status"];
            NSNumber *s= [NSNumber numberWithInt:1];
            if ([status isEqualToNumber:s]){
                NSDictionary *sDic = [responseBody objectForKey:@"data"];
                NSString *str = sDic[@"content"];
                [self.richTextView loadHTMLString:str baseURL:nil];
                
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
