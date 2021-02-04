//
//  BRAboutSoftViewController.m
//  bookReader
//
//  Created by Jobs on 2020/9/11.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRAboutSoftViewController.h"
#import "BRWebviewViewController.h"

#define REQUEST_SUCCEED 200
#define CURRENT_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define BUNDLE_IDENTIFIER [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]
#define TRACK_ID @"TRACKID"
#define APP_LAST_VERSION @"APPLastVersion"
#define APP_RELEASE_NOTES @"APPReleaseNotes"
#define APP_TRACK_VIEW_URL @"APPTRACKVIEWURL"
#define SPECIAL_MODE_CHECK_URL @"https://itunes.apple.com/lookup?country=%@&bundleId=%@&timestamp=%ld"
#define NORMAL_MODE_CHECK_URL @"https://itunes.apple.com/lookup?bundleId=%@&timestamp=%ld"
#define SKIP_CURRENT_VERSION @"SKIPCURRENTVERSION"
#define SKIP_VERSION @"SKIPVERSION"


@interface BRAboutSoftViewController () {
    UILabel *_versionLabel;
    UILabel *_updateLabel;
}

@property (nonatomic, copy) NSString *countryAbbreviation;


@end

@implementation BRAboutSoftViewController


/**
 比较两个版本号的大小
 
 @param v1 第一个版本号
 @param v2 第二个版本号
 @return 版本号相等,返回0; v1小于v2,返回-1; 否则返回1.
 */
- (NSInteger)compareVersion2:(NSString *)v1 to:(NSString *)v2 {
        // 都为空，相等，返回0
        if (!v1 && !v2) {
            return 0;
        }
        // v1为空，v2不为空，返回-1
        if (!v1 && v2) {
            return -1;
        }
        // v2为空，v1不为空，返回1
        if (v1 && !v2) {
            return 1;
        }
        // 获取版本号字段
        NSArray *v1Array = [v1 componentsSeparatedByString:@"."];
        NSArray *v2Array = [v2 componentsSeparatedByString:@"."];
        // 取字段最大的，进行循环比较
        NSInteger bigCount = (v1Array.count > v2Array.count) ? v1Array.count : v2Array.count;

        for (int i = 0; i < bigCount; i++) {
            // 字段有值，取值；字段无值，置0。
            NSInteger value1 = (v1Array.count > i) ? [[v1Array objectAtIndex:i] integerValue] : 0;
            NSInteger value2 = (v2Array.count > i) ? [[v2Array objectAtIndex:i] integerValue] : 0;
            if (value1 > value2) {
                // v1版本字段大于v2版本字段，返回1
                return 1;
            } else if (value1 < value2) {
                // v2版本字段大于v1版本字段，返回-1
                return -1;
            }
            
            // 版本相等，继续循环。
        }

        // 版本号相等
        return 0;
}


- (void)getInfoFromAppStore {
    NSInteger timeStamp = [[NSDate date] timeIntervalSince1970];
    NSURL *requestURL;
    if (self.countryAbbreviation == nil) {
        requestURL = [NSURL URLWithString:[NSString stringWithFormat:NORMAL_MODE_CHECK_URL,BUNDLE_IDENTIFIER,timeStamp]];
    } else {
        requestURL = [NSURL URLWithString:[NSString stringWithFormat:SPECIAL_MODE_CHECK_URL,self.countryAbbreviation,BUNDLE_IDENTIFIER,timeStamp]];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:requestURL];
    NSURLSession *session = [NSURLSession sharedSession];

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
        if (data == nil) {
            return ;
        }
        if (urlResponse.statusCode == REQUEST_SUCCEED) {
            @try {
                NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                if ([responseDic[@"resultCount"] intValue] == 1) {
                    NSArray *results = responseDic[@"results"];
                    NSDictionary *resultDic = [results firstObject];
                    [userDefault setObject:resultDic[@"version"] forKey:APP_LAST_VERSION];
                    [userDefault setObject:resultDic[@"releaseNotes"] forKey:APP_RELEASE_NOTES];
                    [userDefault setObject:resultDic[@"trackViewUrl"] forKey:APP_TRACK_VIEW_URL];
                    [userDefault setObject:resultDic[@"trackId"] forKey:TRACK_ID];
                    if ([resultDic[@"version"] isEqualToString:CURRENT_VERSION] || ![[userDefault objectForKey:SKIP_VERSION] isEqualToString:resultDic[@"version"]]) {
                        [userDefault setBool:NO forKey:SKIP_CURRENT_VERSION];
                    }
                    [userDefault synchronize];
#ifdef DEBUG
                    NSLog(@"*****************\nAPP_LAST_VERSION:\n%@\nAPP_RELEASE_NOTES:\n%@\n*****************",[userDefault objectForKey:APP_LAST_VERSION],[userDefault objectForKey:APP_RELEASE_NOTES]);
#endif
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self compareWithCurrentVersion];
                    });
                }
            } @catch (NSException *exception) {
                NSLog(@"exception.name = %@, exception.reason = %@", exception.name, exception.reason);
            } @finally {

            }
        }
    }];
    [dataTask resume];
}

- (void)compareWithCurrentVersion {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [userDefault objectForKey:APP_LAST_VERSION];
    
    NSInteger result = [self compareVersion2:lastVersion to:CURRENT_VERSION];
    
    if (result == 0) {
        _updateLabel.text = @"当前已是最新版本";
    } else if (result == 1) {
        _updateLabel.text = @"AppStore有新版本请更新~";
    } else if (result == -1) {
        _updateLabel.text = @"";
    }
}

- (void)clickLeftBtn:(id)sender {
    BRWebviewViewController *webVC = [[BRWebviewViewController alloc] init];
    webVC.loadHtmlName = @"yonghuxieyi";
    webVC.headTitle = @"用户协议";
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)clickRightBtn:(id)sender {
    BRWebviewViewController *webVC = [[BRWebviewViewController alloc] init];
    webVC.loadHtmlName = @"yinsizhengce";
    webVC.headTitle = @"隐私政策";
    [self.navigationController pushViewController:webVC animated:YES];
}


#pragma mark- Life Cycle

- (id)init {
    self = [super init];
    if (self) {
        self.enableModule = BaseViewEnableModuleHeadView | BaseViewEnableModuleBackBtn | BaseViewEnableModuleTitle;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    self.headTitle = @"关于软件";
    
    UIImageView *logoImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo"]];
    [self.view addSubview:logoImg];
    [logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.headView.mas_bottom).offset(120);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    _versionLabel = [[UILabel alloc] init];
    _versionLabel.textColor = CFUIColorFromRGBAInHex(0x8F9396, 1);
    _versionLabel.font = [UIFont systemFontOfSize:16];
    _versionLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_versionLabel];
    [_versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(logoImg.mas_bottom).offset(5);
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.height.mas_equalTo(22);
    }];
    
    _versionLabel.text = [NSString stringWithFormat:@"%@ (%@)", kAppVersion, kAppBuildVersion];
    
    
    _updateLabel = [[UILabel alloc] init];
    _updateLabel.textColor = CFUIColorFromRGBAInHex(0x8F9396, 1);
    _updateLabel.font = [UIFont systemFontOfSize:12];
    _updateLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_updateLabel];
    [_updateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_versionLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.height.mas_equalTo(20);
    }];
    _updateLabel.text = @"当前已是最新版本";
    
    
    CGFloat bottom = (BOTTOM_HEIGHT) *(-1);
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:@"用户协议" forState:UIControlStateNormal];
    [leftBtn setTitleColor:CFUIColorFromRGBAInHex(0x3777FF, 1) forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [leftBtn addTarget:self action:@selector(clickLeftBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_centerX).offset(-5);
        make.bottom.mas_equalTo(bottom);
        make.height.mas_equalTo(40);
    }];
    
    
    
    
    
    UILabel *pointLabel = [[UILabel alloc] init];
    pointLabel.textColor = CFUIColorFromRGBAInHex(0x3777FF, 1);
    pointLabel.font = [UIFont systemFontOfSize:12];
    pointLabel.text = @"·";
    pointLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:pointLabel];
    [pointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(leftBtn.mas_centerY).offset(0);
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(0);
        make.bottom.mas_equalTo(bottom);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(10);
    }];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"隐私政策" forState:UIControlStateNormal];
    [rightBtn setTitleColor:CFUIColorFromRGBAInHex(0x3777FF, 1) forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [rightBtn addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_centerX).offset(5);
        make.bottom.mas_equalTo(bottom);
        make.height.mas_equalTo(40);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getInfoFromAppStore];
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
