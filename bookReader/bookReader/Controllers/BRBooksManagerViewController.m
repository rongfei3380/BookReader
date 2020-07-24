//
//  BRBooksManagerViewController.m
//  bookReader
//
//  Created by Jobs on 2020/7/24.
//  Copyright © 2020 chengfeir. All rights reserved.
//

#import "BRBooksManagerViewController.h"
#import "BRBookMangerTableViewCell.h"
#import "BRDataBaseManager.h"
#import "CFButtonUpDwon.h"

@interface BRBooksManagerViewController () {
    NSMutableArray *_selectedBooks;
}

@end

@implementation BRBooksManagerViewController

#pragma mark-Data

- (void)initBooksData {
    _recordsArray = [[[BRDataBaseManager sharedInstance] selectBookInfos] mutableCopy];
    _selectedBooks = [NSMutableArray array];
    [self.tableView reloadData];
}


#pragma mark- button methods

- (void)clickDeleteBtn:(UIButton *)button {
    [self deleteBooks];
}

#pragma mark- private

- (void)initButtons {
    UIView *toolBarView = [[UIView alloc] init];
    toolBarView.backgroundColor = CFUIColorFromRGBAInHex(0xffffff, 1);
    [self.view addSubview:toolBarView];
    [toolBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.bottom.mas_offset(0);
        make.height.mas_offset(BOTTOM_HEIGHT);
    }];
    
    
    CFButtonUpDwon *deleteBtn = [CFButtonUpDwon buttonWithType:UIButtonTypeCustom];
    [deleteBtn setImage:[UIImage imageNamed:@"btn_delete_normal"] forState:UIControlStateNormal];
    [deleteBtn setImage:[UIImage imageNamed:@"btn_delete_selected"] forState:UIControlStateHighlighted];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(clickDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [deleteBtn setTitleColor:CFUIColorFromRGBAInHex(0xF8554F, 1) forState:UIControlStateNormal];
    [deleteBtn setTitleColor:CFUIColorFromRGBAInHex(0xF8554F, 1) forState:UIControlStateHighlighted];
    [toolBarView addSubview:deleteBtn];
    
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.height.mas_offset(49);
        make.top.mas_offset(0);
    }];
    
        
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.enableModule & BaseViewEnableModuleHeadView) {
            make.top.mas_equalTo(self.headView.mas_bottom).offset(0);
        } else {
            make.top.offset(0);
        }
        make.left.right.offset(0);
        make.bottom.mas_equalTo(toolBarView.mas_top).offset(0);
    }];
}

- (void)deleteBooks {
    if (_selectedBooks.count) {
        [[BRDataBaseManager sharedInstance] deleteBookInfoWithBookIds:_selectedBooks];
        
       kWeakSelf(self)
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));

        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [self->_recordsArray removeObjectsInArray:self->_selectedBooks];
            [self->_selectedBooks removeAllObjects];
            kStrongSelf(self)
            [self.tableView reloadData];
        });

        
    }
}

#pragma mark- init


- (id)init {
    self = [super init];
    if (self) {
        self.enableModule = BaseViewEnableModuleHeadView | BaseViewEnableModuleBackBtn | BaseViewEnableModuleBackBtn | BaseViewEnableModuleTitle;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    [self initButtons];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initBooksData];
}


#pragma mark- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    BRBookInfoModel *book = [_recordsArray objectAtIndex:indexPath.row];
    if (book.isSelected.boolValue) {
        book.isSelected = [NSNumber numberWithBool:false];
        [_selectedBooks removeObject:book];
    } else {
        book.isSelected = [NSNumber numberWithBool:true];
        [_selectedBooks addObject:book];
    }
    
    [tableView reloadData];
}

#pragma mark- UITableViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString *doveIdentifier = @"BRBookMangerTableViewCell";
    BRBookMangerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:doveIdentifier];
    if(cell == nil) {
        cell = [[BRBookMangerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:doveIdentifier];
    }
    
    BRBookInfoModel *book = [_recordsArray objectAtIndex:indexPath.row];
    cell.bookInfo = book;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kBookMangerTableViewCellHeight;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _recordsArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
