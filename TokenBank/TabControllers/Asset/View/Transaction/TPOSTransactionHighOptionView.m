//
//  TPOSTransactionHighOptionView.m
//  TokenBank
//
//  Created by MarcusWoo on 09/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSTransactionHighOptionView.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>
#import "TPOSLocalizedHelper.h"

@interface TPOSTransactionHighOptionView()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *gasPriceContainer;
@property (weak, nonatomic) IBOutlet UIView *gasAmountContrainer;
@property (weak, nonatomic) IBOutlet UITextView *hexTextview;
@property (weak, nonatomic) IBOutlet UIView *textviewContainer;
@property (weak, nonatomic) IBOutlet UILabel *placeholder;

@end

@implementation TPOSTransactionHighOptionView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.gasPriceContainer addSubview:self.gasPriceTextfield];
    [self.gasAmountContrainer addSubview:self.gasAmountTextfield];
    
    self.textviewContainer.layer.borderWidth = 1;
    self.textviewContainer.layer.borderColor = [UIColor colorWithHex:0xBEC6CE].CGColor;
    
    self.hexTextview.delegate = self;
    
    [self.gasPriceTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.gasPriceContainer);
    }];
    [self.gasAmountTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.gasAmountContrainer);
    }];
}


- (TPOSTransactionTextField *)gasPriceTextfield {
    if (!_gasPriceTextfield) {
        _gasPriceTextfield = [TPOSTransactionTextField transactionTextfieldWithType:TPOSTransactionTextFieldTypeUnit];
        _gasPriceTextfield.textfield.placeholder = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"custom_gas_price"];
    }
    return _gasPriceTextfield;
}

- (TPOSTransactionTextField *)gasAmountTextfield {
    if (!_gasAmountTextfield) {
        _gasAmountTextfield = [TPOSTransactionTextField transactionTextfieldWithType:TPOSTransactionTextFieldTypeNoraml];
        _gasAmountTextfield.textfield.placeholder = [[TPOSLocalizedHelper standardHelper] stringWithKey:@"custom_gas"];
    }
    return _gasAmountTextfield;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    self.placeholder.hidden = textView.text.length > 0;
}

@end
