//
//  BRWebviewViewController.m
//  bookReader
//
//  Created by Jobs on 2020/9/12.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRWebviewViewController.h"
#import <WebKit/WebKit.h>

@interface BRWebviewViewController ()

@property(nonatomic, strong) WKWebView *webview;

@end

@implementation BRWebviewViewController

#pragma mark- private

- (NSURL *)fileURLForBuggyWKWebView8:(NSURL *)fileURL {
    NSError *error = nil;
    if (!fileURL.fileURL || ![fileURL checkResourceIsReachableAndReturnError:&error]) {
        return nil;
    }
    // Create "/temp/www" directory
    NSFileManager *fileManager= [NSFileManager defaultManager];
    NSURL *temDirURL = [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:@"www"];
    [fileManager createDirectoryAtURL:temDirURL withIntermediateDirectories:YES attributes:nil error:&error];
    
    NSURL *dstURL = [temDirURL URLByAppendingPathComponent:fileURL.lastPathComponent];
    // Now copy given file to the temp directory
    [fileManager removeItemAtURL:dstURL error:&error];
    [fileManager copyItemAtURL:fileURL toURL:dstURL error:&error];
    // Files in "/temp/www" load flawlesly :)
    return dstURL;
}

-(WKWebView *)webview{
    if (!_webview) {
        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";

        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];

        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        wkWebConfig.userContentController = wkUController;

        // 创建设置对象
        WKPreferences *preference = [[WKPreferences alloc]init];
        // 设置字体大小(最小的字体大小)
        preference.minimumFontSize = 15;
        // 设置偏好设置对象
        wkWebConfig.preferences = preference;
        
        
        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(self.headView.frame)) configuration:wkWebConfig];
        webView.scrollView.alwaysBounceVertical = NO;
//        [Toolkit setContentInsetAdjustmentBehaviorNever4ScrollView:webView.scrollView];
        _webview = webView;
    }
    return _webview;
}

#pragma mark- LifeCycle

- (id)init {
    self = [super init];
    if (self) {
        self.enableModule = BaseViewEnableModuleHeadView | BaseViewEnableModuleTitle | BaseViewEnableModuleBackBtn;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.webview];
    [self.webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headView.mas_bottom).offset(0);
        make.left.right.bottom.mas_equalTo(0);
    }];

    NSString *path = [[NSBundle mainBundle] pathForResource:self.loadHtmlName ofType:@"html"];

    if(path){
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
            // iOS9. One year later things are OK.
            NSURL *fileURL = [NSURL fileURLWithPath:path];
            [self.webview loadFileURL:fileURL allowingReadAccessToURL:fileURL];
//注释的方法和上面的方法是等价的,两者都可以使用
//            NSString * htmlCont = [NSString stringWithContentsOfFile:path
//                                                                                       encoding:NSUTF8StringEncoding
//                                                                                          error:nil];
//            [self.webview loadHTMLString:htmlCont baseURL:[NSBundle mainBundle].resourceURL];
        } else {
            // iOS8
            NSURL *fileURL = [self fileURLForBuggyWKWebView8:[NSURL fileURLWithPath:path]];
            NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
            [self.webview loadRequest:request];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
