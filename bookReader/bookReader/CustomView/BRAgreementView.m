//
//  BRAgreementView.m
//  bookReader
//
//  Created by Jobs on 2020/9/13.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRAgreementView.h"
#import "CFCustomMacros.h"
#import <Masonry.h>
#import "CFUtils.h"

@implementation BRAgreementView

#pragma private

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
        
        
        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:wkWebConfig];
        webView.scrollView.alwaysBounceVertical = NO;
        webView.navigationDelegate = self;

//        [Toolkit setContentInsetAdjustmentBehaviorNever4ScrollView:webView.scrollView];
        _webview = webView;
    }
    return _webview;
}


#pragma LifeClycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = CFUIColorFromRGBAInHex(0x000000, 0.5);
        
        _contentViewBg = [[UIView alloc] init];
        _contentViewBg.clipsToBounds = YES;
        _contentViewBg.layer.cornerRadius = 16.f;
        _contentViewBg.backgroundColor = CFUIColorFromRGBAInHex(0xffffff, 1);
        [self addSubview:_contentViewBg];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = CFUIColorFromRGBAInHex(0xE5E5E5, 1);
        [_contentViewBg addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(68);
            make.height.mas_equalTo(0.5);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:20];
        titleLabel.text = @"特别提示";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [_contentViewBg addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_contentViewBg.mas_centerX).offset(0);
            make.top.mas_equalTo(24);
            make.height.mas_equalTo(26);
        }];
        
        [_contentViewBg addSubview:self.webview];
        [self.webview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(25);
            make.right.mas_equalTo(-25);
            make.top.mas_equalTo(lineView.mas_bottom).offset(0);
            make.bottom.mas_equalTo(-138);
        }];
        
        _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkBtn setImage:[UIImage imageNamed:@"icon_radio_normal"] forState:UIControlStateNormal];
        [_checkBtn setImage:[UIImage imageNamed:@"icon_radio_selected"] forState:UIControlStateSelected];
        [_checkBtn addTarget:self action:@selector(clickCheckBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_contentViewBg addSubview:_checkBtn];
        [_checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.webview.mas_bottom).offset(15);
            make.left.mas_equalTo(25);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        
        UILabel *agreementLabel = [[UILabel alloc] init];
        agreementLabel.text = @"如你同意，请点击“同意并继续”开始 接受我们的服务。";
        agreementLabel.numberOfLines = 0;
        agreementLabel.font = [UIFont fontWithName:@"PingFang SC" size:15];
        agreementLabel.textColor = CFUIColorFromRGBAInHex(0x292F3D, 1);
        [_contentViewBg addSubview:agreementLabel];
        [agreementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.webview.mas_bottom).offset(15);
            make.left.mas_equalTo(50);
            make.right.mas_equalTo(-25);
        }];
        
        _agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_agreementBtn setBackgroundImage:[CFUtils pureColorImage:0x3E85FF colorAlpha:1 size:CGSizeMake(44, 44)] forState:UIControlStateNormal];
        [_agreementBtn setTitle:@"同意并继续" forState:UIControlStateNormal];
        [_agreementBtn addTarget:self action:@selector(clickAgreementBtn:) forControlEvents:UIControlEventTouchUpInside];
        _agreementBtn.clipsToBounds = YES;
        _agreementBtn.layer.cornerRadius = 4.f;
        _agreementBtn.userInteractionEnabled = NO;
        [_contentViewBg addSubview:_agreementBtn];
        [_agreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(25);
            make.right.mas_equalTo(-25);
            make.height.mas_equalTo(44);
            make.top.mas_equalTo(agreementLabel.mas_bottom).offset(21);
        }];
        
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_contentViewBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(52);
        make.bottom.mas_equalTo(-52);
    }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
      NSString *path = [[NSBundle mainBundle] pathForResource:@"tanchuangtishi" ofType:@"html"];

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

#pragma mark - private method
- (void)handleCustomAction:(NSURL *)URL {
    NSString *host = [URL host];
    if ([host isEqualToString:@"webView"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(agreementViewDelegateClickLink:)]) {
            [self.delegate agreementViewDelegateClickLink:URL];
        }

    } else if ([host isEqualToString:@"shareClick"]) {
        
    } 
}

- (void)clickCheckBtn:(id)sender {
    _checkBtn.selected = !_checkBtn.selected;
    if (_checkBtn.selected) {
        _agreementBtn.userInteractionEnabled = YES;
    } else {
        _agreementBtn.userInteractionEnabled = NO;
    }
}

- (void)clickAgreementBtn:(id)sender {
    if (_checkBtn.selected) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(agreementViewDelegateAgreementViewDissmiss:)]) {
            [self.delegate agreementViewDelegateAgreementViewDissmiss:self];
        }
    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
//    bookRead://webView/yonghuxieyi
    if ([scheme isEqualToString:@"bookread"]) {
        [self handleCustomAction:URL];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

@end
