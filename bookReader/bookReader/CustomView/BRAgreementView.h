//
//  BRAgreementView.h
//  bookReader
//
//  Created by Jobs on 2020/9/13.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BRAgreementViewDelegate <NSObject>

- (void)agreementViewDelegateClickLink:(NSURL *)url;
- (void)agreementViewDelegateAgreementViewDissmiss:(UIView *)view;

@end

/// 用户协议页面
@interface BRAgreementView : UIView<WKNavigationDelegate> {
    UIView *_contentViewBg;
    UIButton *_checkBtn;
    UIButton *_agreementBtn;
}

@property(strong, nonatomic) WKWebView *webview;
@property(weak, nonatomic) id<BRAgreementViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
