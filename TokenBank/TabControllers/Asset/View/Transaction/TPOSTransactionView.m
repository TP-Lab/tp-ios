//
//  TPOSTransactionView.m
//  TokenBank
//
//  Created by MarcusWoo on 08/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSTransactionView.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>
#import "TPOSTransactionTextField.h"
#import "TPOSTransactionNormalOptionView.h"
#import "TPOSTransactionHighOptionView.h"
#import "UIImage+TPOS.h"
#import "TPOSMacro.h"
#import "TPOSLocalizedHelper.h"

@interface TPOSTransactionView()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) TPOSTransactionTextField *addrTextfield;
@property (nonatomic, strong) TPOSTransactionTextField *amountTextfield;
@property (nonatomic, strong) TPOSTransactionTextField *remarkTextfield;
//option view
@property (nonatomic, strong) UIScrollView *horizontalScrollView;
@property (nonatomic, strong) UIView *horizontalContentView;
@property (nonatomic, strong) TPOSTransactionNormalOptionView *normalOView;
@property (nonatomic, strong) TPOSTransactionHighOptionView *highOView;
//setting
@property (nonatomic, strong) UIButton *paramsHelpBtn;
@property (nonatomic, strong) UILabel *highLevelTitle;
@property (nonatomic, strong) UISwitch *switchBtn;
//next
@property (nonatomic, strong) UIButton *nextButton;
@end

@implementation TPOSTransactionView

- (instancetype)init {
    if (self = [super init]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    [self addMainScrollView];
    [self addTransactionInfoTextfields];
    [self addOptionScrollView];
    [self addBottomViews];
}

#pragma mark - Public

- (void)fillToAddress:(NSString *)address {
    self.addrTextfield.textfield.text = address;
}

- (void)fillToAmount:(CGFloat)amount {
    self.amountTextfield.textfield.text = [NSString stringWithFormat:@"%0.8f",amount];
}

- (void)fillRemark:(NSString *)remarkString {
    self.remarkTextfield.textfield.text = remarkString;
}

#pragma mark - Event
- (void)onNextButtonTapped:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(TPOSTransactionViewDidTapNextButton)]) {
        [self.delegate TPOSTransactionViewDidTapNextButton];
    }
}

- (void)onParamsButtonTapped:(UIButton *)btn {
    TPOSLog(@"onParamsButtonTapped");
}

- (void)onSwitchBtnTapped:(UISwitch *)btn {
    BOOL isHighLevel = btn.isOn;
    btn.on = !btn.isOn;
    [self.horizontalScrollView setContentOffset:CGPointMake(isHighLevel?0:CGRectGetWidth(self.contentView.frame), 0) animated:YES];
}

#pragma mark - Getter
//scrollview
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
    }
    return _contentView;
}

- (void)addMainScrollView {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.scrollView);
        make.width.equalTo(@([UIScreen mainScreen].bounds.size.width));
    }];
}

- (void)addTransactionInfoTextfields {
    [self.contentView addSubview:self.addrTextfield];
    [self.contentView addSubview:self.amountTextfield];
    [self.contentView addSubview:self.remarkTextfield];
    
    [self.addrTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.equalTo(@50);
    }];
    [self.amountTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.addrTextfield.mas_bottom);
        make.height.equalTo(@50);
    }];
    [self.remarkTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.amountTextfield.mas_bottom);
        make.height.equalTo(@50);
    }];
}

- (TPOSTransactionTextField *)addrTextfield {
    if (!_addrTextfield) {
        _addrTextfield = [TPOSTransactionTextField transactionTextfieldWithType:TPOSTransactionTextFieldTypeContact];
        _addrTextfield.textfield.text = @"";
    }
    return _addrTextfield;
}

- (TPOSTransactionTextField *)amountTextfield {
    if (!_amountTextfield) {
        _amountTextfield = [TPOSTransactionTextField transactionTextfieldWithType:TPOSTransactionTextFieldTypeNoraml];
        _amountTextfield.textfield.text = @"0";
    }
    return _amountTextfield;
}

- (TPOSTransactionTextField *)remarkTextfield {
    if (!_remarkTextfield) {
        _remarkTextfield = [TPOSTransactionTextField transactionTextfieldWithType:TPOSTransactionTextFieldTypeNoraml];
        _remarkTextfield.textfield.placeholder = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"comment"];
    }
    return _remarkTextfield;
}

- (void)addOptionScrollView {
    [self.contentView addSubview:self.horizontalScrollView];
    [self.horizontalScrollView addSubview:self.horizontalContentView];
    [self.horizontalContentView addSubview:self.normalOView];
    [self.horizontalContentView addSubview:self.highOView];
    
    [self.horizontalScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.remarkTextfield.mas_bottom);
        make.height.equalTo(@235);
    }];
    [self.horizontalContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.horizontalScrollView);
        make.height.equalTo(@235);
    }];
    [self.normalOView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.horizontalContentView);
        make.width.equalTo(self.contentView.mas_width);
    }];
    [self.highOView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.horizontalContentView);
        make.left.equalTo(self.normalOView.mas_right);
        make.width.equalTo(self.normalOView.mas_width);
    }];
}

- (UIScrollView *)horizontalScrollView {
    if (!_horizontalScrollView) {
        _horizontalScrollView = [[UIScrollView alloc] init];
        _horizontalScrollView.showsHorizontalScrollIndicator = NO;
        _horizontalScrollView.scrollEnabled = NO;
    }
    return _horizontalScrollView;
}

- (UIView *)horizontalContentView {
    if (!_horizontalContentView) {
        _horizontalContentView = [UIView new];
    }
    return _horizontalContentView;
}

- (TPOSTransactionNormalOptionView *)normalOView {
    if (!_normalOView) {
        _normalOView = (TPOSTransactionNormalOptionView *)[[NSBundle mainBundle] loadNibNamed:@"TPOSTransactionNormalOptionView" owner:nil options:nil].firstObject;
    }
    return _normalOView;
}

- (TPOSTransactionHighOptionView *)highOView {
    if (!_highOView) {
        _highOView = (TPOSTransactionHighOptionView *)[[NSBundle mainBundle] loadNibNamed:@"TPOSTransactionHighOptionView" owner:nil options:nil].firstObject;
    }
    return _highOView;
}

- (void)addBottomViews {
    [self.contentView addSubview:self.paramsHelpBtn];
    [self.contentView addSubview:self.highLevelTitle];
    [self.contentView addSubview:self.switchBtn];
    [self.contentView addSubview:self.nextButton];
    
    [self.paramsHelpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.horizontalScrollView.mas_bottom).offset(16);
        make.width.equalTo(@100);
        make.height.equalTo(@15);
    }];
    [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.centerY.equalTo(self.paramsHelpBtn.mas_centerY);
    }];
    [self.highLevelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.switchBtn.mas_left).offset(5);
        make.centerY.equalTo(self.paramsHelpBtn.mas_centerY);
        make.width.equalTo(@100);
        make.height.equalTo(@20);
    }];
    
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.equalTo(@45);
        make.top.equalTo(self.highLevelTitle.mas_bottom).offset(50);
        make.bottom.equalTo(self.contentView).offset(-50);
    }];
}

- (UIButton *)paramsHelpBtn {
    if (!_paramsHelpBtn) {
        _paramsHelpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_paramsHelpBtn setTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"how_to"] forState:UIControlStateNormal];
        [_paramsHelpBtn setTitleColor:[UIColor colorWithHex:0x5DB8C6] forState:UIControlStateNormal];
        _paramsHelpBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _paramsHelpBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_paramsHelpBtn addTarget:self action:@selector(onParamsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _paramsHelpBtn;
}

- (UILabel *)highLevelTitle {
    if (!_highLevelTitle) {
        _highLevelTitle = [[UILabel alloc] init];
        _highLevelTitle.font = [UIFont systemFontOfSize:15];
        _highLevelTitle.textColor = [UIColor colorWithHex:0x88939E];
        _highLevelTitle.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"advanced"];
        _highLevelTitle.textAlignment = NSTextAlignmentRight;
    }
    return _highLevelTitle;
}

- (UISwitch *)switchBtn {
    if (!_switchBtn) {
        _switchBtn = [UISwitch new];
        _switchBtn.onTintColor = [UIColor colorWithHex:0x5DB8C6];
        _switchBtn.on = NO;
        _switchBtn.transform = CGAffineTransformMakeScale(0.6, 0.6);
        [_switchBtn addTarget:self action:@selector(onSwitchBtnTapped:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchBtn;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setBackgroundImage:[UIImage tb_imageWithColor:[UIColor colorWithHex:0x5DB8C6] andSize:CGSizeMake(kScreenWidth - 40, 45)] forState:UIControlStateNormal];
        [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextButton setTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"next_step"] forState:UIControlStateNormal];
        _nextButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _nextButton.layer.cornerRadius = 3;
        _nextButton.layer.masksToBounds = YES;
        [_nextButton addTarget:self action:@selector(onNextButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}

- (CGFloat)minerfee {
    return self.normalOView.minerFee;
}

- (CGFloat)transAmount {
    CGFloat amount = [self.amountTextfield.textfield.text floatValue];
    return amount ? amount : 0;
}

- (NSString *)address {
    return self.addrTextfield.textfield.text;
}

- (NSString *)highLevelGas {
    return self.highOView.gasAmountTextfield.textfield.text;
}

- (NSString *)highLevelGasPrice {
    return self.highOView.gasPriceTextfield.textfield.text;
}

- (BOOL)isHighLevel {
    return self.switchBtn.isOn;
}

@end
