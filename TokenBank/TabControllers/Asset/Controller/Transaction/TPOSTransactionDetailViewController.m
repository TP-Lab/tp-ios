//
//  TPOSTransactionDetailViewController.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/1/21.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSTransactionDetailViewController.h"
#import "UIColor+Hex.h"
#import "UIImage+TPOS.h"
#import "TPOSTransactionRecoderModel.h"
#import "NSDate+TPOS.h"
#import "TPOSWeb3Handler.h"
#import "TPOSH5ViewController.h"
#import "NSString+TPOS.h"
#import "SGQRCodeGenerateManager.h"
#import "TPOSJTPaymentInfo.h"
#import "TPOSMacro.h"

@import Toast;

@interface TPOSTransactionDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *tokenValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *tokenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *toLabel;
@property (weak, nonatomic) IBOutlet UILabel *gasLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarksLabel;
@property (weak, nonatomic) IBOutlet UIButton *transactionOrderButton;
@property (weak, nonatomic) IBOutlet UILabel *blockLabel;
@property (weak, nonatomic) IBOutlet UILabel *transactionTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *copyyButton;
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;


@property (weak, nonatomic) IBOutlet UILabel *senderLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiverLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *transNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *blcNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *transTimeLabel;


@end

@implementation TPOSTransactionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"trans_detail"];
    [self updateUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
}

- (void)viewDidReceiveLocalizedNotification {
    [super viewDidReceiveLocalizedNotification];
}

- (void)changeLanguage {
    self.senderLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"sender"];
    self.receiverLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"receiver"];
    self.feeLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"miner_fee"];
    self.commentLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"comment"];
    self.transNumLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"trans_num"];
    self.blcNumLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"blc_num"];
    self.transTimeLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"trans_time"];
    [self.copyyButton setTitle:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"copy_url"] forState:UIControlStateNormal];
}

- (UIButton *)backStyleButton {
    UIButton *button = [super backStyleButton];
    [button setImage:[[UIImage imageNamed:@"icon_navi_back"] tb_imageWithTintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    return button;
}

- (void)updateUI {
    self.copyyButton.layer.cornerRadius = 4;
    self.copyyButton.layer.masksToBounds = YES;
    if (_transactionRecoderModel) {
        BOOL isOut = NO;
        if ([[_transactionRecoderModel.from uppercaseString] isEqualToString:[_currentAddress uppercaseString]]) {
            isOut = YES;
        } else {
            isOut = NO;
        }
        __weak typeof(self) weakSelf = self;
        NSString *value;
        if ([_transactionRecoderModel.type isEqualToString:nonnativeToken]) { //代币
            value = _transactionRecoderModel.token_value;
            if (value && _transactionRecoderModel.decimal) {
                NSDecimalNumber *balance = [NSDecimalNumber decimalNumberWithString:value];
                NSInteger dec = [_transactionRecoderModel.decimal longLongValue];
                NSDecimalNumber *p = [NSDecimalNumber decimalNumberWithMantissa:10 exponent:(dec>0?dec:18)-1 isNegative:NO];
                NSDecimalNumberHandler *handler = [[NSDecimalNumberHandler alloc] initWithRoundingMode:NSRoundPlain scale:4 raiseOnExactness:NO raiseOnOverflow:YES raiseOnUnderflow:YES raiseOnDivideByZero:YES];
                NSDecimalNumber *result = [balance decimalNumberByDividingBy:p withBehavior:handler];
                value = [result stringValue];
            } else {
                value = @"0";
            }
            self.tokenValueLabel.text = [NSString stringWithFormat:@"%@%@", isOut ? @"-":@"+" ,value];
        } else {
            value = _transactionRecoderModel.value;
            [[TPOSWeb3Handler sharedManager] weiChangeToTokenOfTokenType:nil withCount:value callBack:^(id responseObject) {
                weakSelf.tokenValueLabel.text = [NSString stringWithFormat:@"%@%@", isOut ? @"-":@"+", responseObject];
            }];
        }
        
        self.gasLabel.text = [NSString stringWithFormat:@"%@ ETH", _transactionRecoderModel.fee];
        
        _tokenNameLabel.text = [_transactionRecoderModel.symbol tb_isEmpty] ? @"Unknown":weakSelf.transactionRecoderModel.symbol;
        _fromLabel.text = _transactionRecoderModel.from;
        _toLabel.text = _transactionRecoderModel.to;
        _blockLabel.text = [NSString stringWithFormat:@"%@",_transactionRecoderModel.block_number];
        [_transactionOrderButton setTitle:_transactionRecoderModel.hashKey forState:UIControlStateNormal];
        _transactionTimeLabel.text = [NSDate dateDescriptionFrom:_transactionRecoderModel.timestamp];
        
        if ([_transactionRecoderModel.status isEqualToString:transactionFail]) {
            _statusLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"trans_fail"];
        } else if ([_transactionRecoderModel.status isEqualToString:transactionSuccess]) {
            _statusLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"trans_succ"];
        } else {
            _statusLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"transing"];
        }
        NSString *url = [NSString stringWithFormat:@"https://etherscan.io/tx/%@", _transactionRecoderModel.hashKey];
        if (![TPOSWeb3Handler isTransaction:_transactionRecoderModel.input]) {
            [[TPOSWeb3Handler sharedManager] hexToString:_transactionRecoderModel.input callBack:^(id responseObject) {
                weakSelf.remarksLabel.text = responseObject;
            }];
        }
        
        self.qrCodeImageView.image = [SGQRCodeGenerateManager generateWithDefaultQRCodeData:url imageViewWidth:125];
    } else {
        BOOL isOut = NO;
        if ([_payInfo.type isEqualToString:@"sent"]) {
            _fromLabel.text = _currentAddress;
            _toLabel.text = _payInfo.counterparty;
            isOut = YES;
        } else {
            _fromLabel.text = _payInfo.counterparty;
            _toLabel.text = _currentAddress;
        }
        _blockLabel.text = [NSString stringWithFormat:@"%@",_payInfo.py_hash];
        [_transactionOrderButton setTitle:_payInfo.py_hash forState:UIControlStateNormal];
        _transactionTimeLabel.text = [NSDate dateDescriptionFrom:[_payInfo.date longLongValue]];
        _tokenValueLabel.text = [NSString stringWithFormat:@"%@%@",isOut?@"-":@"+", _payInfo.amount.value];
        _tokenNameLabel.text = _payInfo.amount.currency;
        _statusLabel.text = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"trans_succ"];
        _gasLabel.text = [NSString stringWithFormat:@"%@ SWT",_payInfo.fee];
        _remarksLabel.text = _payInfo.memos.firstObject;
        NSString *url = [NSString stringWithFormat:@"http://state.jingtum.com/#!/tx/%@", _payInfo.py_hash];
        self.qrCodeImageView.image = [SGQRCodeGenerateManager generateWithDefaultQRCodeData:url imageViewWidth:125];
    }
}

- (IBAction)coryyAction:(id)sender {
    
    NSString *url = @"";
    if ([ethChain isEqualToString:_blockChainId]) {
        url = [NSString stringWithFormat:@"https://etherscan.io/tx/%@", _transactionRecoderModel.hashKey];
    } else {
        url = [NSString stringWithFormat:@"http://state.jingtum.com/#!/tx/%@", _payInfo.py_hash];
    }
    
    [[UIPasteboard generalPasteboard] setString:url];
    [self.view makeToast:[[TPOSLocalizedHelper standardHelper] stringWithKey:@"copy_to_board"]];
}

- (IBAction)transactionOrderAction:(id)sender {
    TPOSH5ViewController *h5VC = [[TPOSH5ViewController alloc] init];
    h5VC.titleString = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"trans_query"];
    if ([ethChain isEqualToString:_blockChainId]) {
        h5VC.urlString = [NSString stringWithFormat:@"https://etherscan.io/tx/%@", _transactionRecoderModel.hashKey];
    } else {
        h5VC.urlString = [NSString stringWithFormat:@"http://state.jingtum.com/#!/tx/%@", _payInfo.py_hash];
    }
    [self.navigationController pushViewController:h5VC animated:YES];
}

@end
