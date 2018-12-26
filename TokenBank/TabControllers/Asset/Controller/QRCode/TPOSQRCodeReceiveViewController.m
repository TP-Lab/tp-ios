//
//  TPOSQRCodeReceiveViewController.m
//  TokenBank
//
//  Created by MarcusWoo on 07/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSQRCodeReceiveViewController.h"
#import "UIColor+Hex.h"
#import "TPOSMacro.h"
#import "SGQRCodeGenerateManager.h"
#import "TPOSContext.h"
#import "TPOSWalletModel.h"
#import "TPOSWeb3Handler.h"
#import "UIImage+TPOS.h"
#import "TPOSShareMenuView.h"
#import "TPOSShareView.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>

@import Masonry;

@interface TPOSQRCodeReceiveViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *codeScrollView;
@property (nonatomic, strong) UIView *codeBg;
@property (nonatomic, strong) UIImageView *codeImgV;

@property (nonatomic, strong) UIView *amountBg;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *receiveLabel;
@property (nonatomic, strong) UITextField *amountTextField;
@property (nonatomic, strong) UILabel *unitLabel;

@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *addressCopyLabel;
@property (nonatomic, strong) UIButton *addressButton;
@property (nonatomic, strong) UIView *contentView;
@end

@implementation TPOSQRCodeReceiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self setupConstraints];
    
    self.title = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"receive"];
    
    self.addressLabel.text = self.address;
    
    self.unitLabel.text = self.tokenType?:@"ETH";
    
    if (_tokenAmount > 0) {
        NSString *amountString = [NSString stringWithFormat:@"%0.4f",_tokenAmount];
        self.amountTextField.text = amountString;
        [self generateQRCodeWithAmount:amountString];
    } else {
        NSString *amountString = @"0";
        self.amountTextField.text = nil;
        [self generateQRCodeWithAmount:amountString];
    }
}

- (void)responseLeftButton {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)responseRightButton {
    __weak typeof(self) weakSelf = self;
    [TPOSShareMenuView showInView:nil complement:^(TPOSShareType type) {
        UIImage *image = [TPOSShareView shareImageByQrcodeImage:weakSelf.codeImgV.image address:weakSelf.address];
        [weakSelf shareActionWithImage:image type:type];
    }];
}

- (void)shareActionWithImage:(UIImage *)image type:(TPOSShareType)type {
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    NSData *thumbData = UIImageJPEGRepresentation(image, 0.01);
    if (type < TPOSShareTypeQQSession) {
        WXImageObject *imageObject = [WXImageObject object];
        imageObject.imageData = imageData;
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        WXMediaMessage *message = [WXMediaMessage message];
        message.mediaObject = imageObject;
        message.thumbData = thumbData;
        req.bText = NO;
        if (type == TPOSShareTypeWechatSession) {
            req.scene = WXSceneSession;
        } else {
            req.scene = WXSceneTimeline;
        }
        req.message = message;
        BOOL result = [WXApi sendReq:req];
        if (result) {
            
        }
    } else {
        QQApiImageObject *obj = [[QQApiImageObject alloc] init];
        obj.data = imageData;
        obj.previewImageData = thumbData;
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:obj];
        BOOL result = [QQApiInterface sendReq:req];
        if (result) {
            
        }
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavigationBarStyle];
}

- (void)setNavigationBarStyle {
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)setupSubviews {
    [self addLeftBarButtonImage:[[UIImage imageNamed:@"icon_guanbi"] tb_imageWithTintColor:[UIColor whiteColor]] action:@selector(responseLeftButton)];
    [self addRightBarButtonImage:[UIImage imageNamed:@"icon_share"] action:@selector(responseRightButton)];
    self.view.backgroundColor = [UIColor colorWithHex:0xf5f5f9];
    [self.view addSubview:self.codeScrollView];
    [self.codeScrollView addSubview:self.contentView];
    [self.contentView addSubview:self.codeBg];
    [self.codeBg addSubview:self.codeImgV];
    
    [self.contentView addSubview:self.amountBg];
    [self.amountBg addSubview:self.line];
    [self.amountBg addSubview:self.receiveLabel];
    [self.amountBg addSubview:self.unitLabel];
    [self.amountBg addSubview:self.amountTextField];
    
    [self.contentView addSubview:self.addressButton];
    [self.addressButton addSubview:self.addressLabel];
    [self.addressButton addSubview:self.addressCopyLabel];
}

- (void)setupConstraints {
    
    [self.codeScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.codeScrollView);
        make.centerX.equalTo(self.codeScrollView.mas_centerX);
        make.bottom.equalTo(self.addressButton.mas_bottom).offset(20);
    }];
    
    [self.codeBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(@298);
    }];
    
    [self.codeImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.codeBg.mas_centerX);
        make.centerY.equalTo(self.codeBg.mas_centerY);
        make.width.height.equalTo(@190);
    }];
    
    [self.amountBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.codeBg.mas_bottom);
        make.height.equalTo(@66);
    }];

    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.amountBg.mas_left).offset(25);
        make.right.equalTo(self.amountBg.mas_right).offset(-25);
        make.top.equalTo(self.amountBg.mas_top);
        make.height.equalTo(@0.5);
    }];
    
    [self.receiveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line.mas_left);
        make.width.equalTo(@70);
        make.top.bottom.equalTo(self.amountBg);
    }];
    
    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.line.mas_right);
        make.width.equalTo(@70);
        make.top.bottom.equalTo(self.amountBg);
    }];
    
    [self.amountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.receiveLabel.mas_right).offset(20);
        make.right.equalTo(self.unitLabel.mas_left).offset(-20);
        make.height.equalTo(self.amountBg);
        make.centerY.equalTo(self.receiveLabel.mas_centerY);
    }];
    
    [self.addressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.amountBg.mas_bottom).offset(10);
        make.height.equalTo(@80);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressButton.mas_left).offset(25);
        make.right.equalTo(self.addressButton.mas_right).offset(-25);
        make.top.equalTo(self.addressButton.mas_top).offset(5);
        make.height.equalTo(@40);
    }];
    
    [self.addressCopyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.addressButton).offset(-5);
        make.height.equalTo(@35);
    }];
}

#pragma mark - Event
- (void)onCopyButtonTapped:(UIButton *)btn {
    if (self.addressLabel.text.length > 0) {
        self.addressCopyLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"copied"];
        [[UIPasteboard generalPasteboard] setString:self.addressLabel.text];
    }
}

- (void)onCloseBtnTapped:(UIButton *)btn {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFiledDidChange:(UITextField *)textfield {
    NSString *amountString = textfield.text;
    if ([amountString rangeOfString:@"."].location == 0) {
        amountString = [NSString stringWithFormat:@"0%@",amountString];
        textfield.text = amountString;
    }
    [self generateQRCodeWithAmount:[NSString stringWithFormat:@"%0.4f",[amountString floatValue]]];
    self.addressCopyLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"copy_wallet_addr"];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.text.length == 1) {
        if ([textField.text isEqualToString:@"0"] && [string isEqualToString:@"0"]) {
            return NO;
        }
    }
    
    //如果输入的是“.”  判断之前已经有"."或者字符串为空
    if ([string isEqualToString:@"."] && ([textField.text rangeOfString:@"."].location != NSNotFound)) {
        return NO;
    }
    //拼出输入完成的str,判断str的长度大于“.”的位置＋4,则返回false,此次插入string失败 （"379132.424",长度10,"."的位置6, 10>=6+4）
    NSMutableString *str = [[NSMutableString alloc] initWithString:textField.text];
    [str insertString:string atIndex:range.location];
    if (str.length > [str rangeOfString:@"."].location+5){
        return NO;
    }
        
    return YES;
}


- (void)generateQRCodeWithAmount:(NSString *)amount {
    
    if (self.basicType == TPOSBasicTokenTypeEtheruem) {
        __weak typeof(self) weakSelf = self;
        [[TPOSWeb3Handler sharedManager] changeToIbanWithAddress:_address callBack:^(id responseObject) {
            NSString *codeString = [NSString stringWithFormat:@"iban:%@?amount=%@&token=%@",responseObject,amount,_tokenType?:@"ETH"];
            weakSelf.codeImgV.image = [SGQRCodeGenerateManager generateWithDefaultQRCodeData:codeString imageViewWidth:190];
        }];
    } else if (self.basicType == TPOSBasicTokenTypeJingTum) {
        NSString *codeString = [NSString stringWithFormat:@"jingtum:%@?amount=%@&token=%@",self.address,amount,self.tokenType];
        self.codeImgV.image = [SGQRCodeGenerateManager generateWithDefaultQRCodeData:codeString imageViewWidth:190];
    }
}


#pragma mark - Getter & Setter
- (UIScrollView *)codeScrollView {
    if (!_codeScrollView) {
        _codeScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    }
    return _codeScrollView;
}

- (UIImageView *)codeImgV {
    if (!_codeImgV) {
        _codeImgV = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _codeImgV;
}

- (UIView *)codeBg {
    if (!_codeBg) {
        _codeBg = [[UIView alloc] init];
        _codeBg.backgroundColor = [UIColor colorWithHex:0xffffff];
    }
    return _codeBg;
}

- (UIView *)amountBg {
    if (!_amountBg) {
        _amountBg = [[UIView alloc] init];
        _amountBg.backgroundColor = [UIColor whiteColor];
    }
    return _amountBg;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectZero];
        _line.backgroundColor = [UIColor colorWithHex:0xe0e4e8];
    }
    return _line;
}

- (UILabel *)receiveLabel {
    if (!_receiveLabel) {
        _receiveLabel = [[UILabel alloc] init];
        _receiveLabel.font = [UIFont systemFontOfSize:16];
        _receiveLabel.textColor = [UIColor colorWithHex:0x333333];
        _receiveLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"rece_amount"];
    }
    return _receiveLabel;
}

- (UILabel *)unitLabel {
    if (!_unitLabel) {
        _unitLabel = [[UILabel alloc] init];
        _unitLabel.font = [UIFont systemFontOfSize:16];
        _unitLabel.textColor = [UIColor colorWithHex:0x333333];
        _unitLabel.textAlignment = NSTextAlignmentRight;
    }
    return _unitLabel;
}

- (UITextField *)amountTextField {
    if (!_amountTextField) {
        _amountTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _amountTextField.textColor = [UIColor colorWithHex:0x333333];
        _amountTextField.textAlignment = NSTextAlignmentCenter;
        _amountTextField.font = [UIFont systemFontOfSize:16];
        _amountTextField.placeholder = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"set_rec_amount"];
        [_amountTextField addTarget:self action:@selector(textFiledDidChange:) forControlEvents:UIControlEventEditingChanged];
        _amountTextField.keyboardType = UIKeyboardTypeDecimalPad;
        _amountTextField.delegate = self;
    }
    return _amountTextField;
}

- (UIButton *)addressButton {
    if (!_addressButton) {
        _addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addressButton setTitleColor:[UIColor colorWithHex:0x2890FE] forState:UIControlStateNormal];
        [_addressButton addTarget:self action:@selector(onCopyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        _addressButton.backgroundColor = [UIColor colorWithHex:0xffffff];
    }
    return _addressButton;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _addressLabel.textColor = [UIColor colorWithHex:0x333333];
        _addressLabel.font = [UIFont systemFontOfSize:12];
        _addressLabel.textAlignment = NSTextAlignmentCenter;
        _addressLabel.numberOfLines = 2;
    }
    return _addressLabel;
}

- (UILabel *)addressCopyLabel {
    if (!_addressCopyLabel) {
        _addressCopyLabel = [[UILabel alloc] init];
        _addressCopyLabel.textColor = [UIColor colorWithHex:0x2890fe];
        _addressCopyLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"copy_wallet_addr"];
        _addressCopyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _addressCopyLabel;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}

@end
