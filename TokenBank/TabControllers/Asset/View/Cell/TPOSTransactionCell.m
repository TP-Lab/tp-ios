//
//  TPOSTransactionCellTableViewCell.m
//  TokenBank
//
//  Created by xiaoyuan on 2018/2/3.
//  Copyright © 2018年 MarcusWoo. All rights reserved.
//

#import "TPOSTransactionCell.h"
#import "UIColor+Hex.h"

@import Masonry;

@interface TPOSTransactionCell() <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
//@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UITextField *inputTextField;

@end

@implementation TPOSTransactionCell

+ (NSString *)reuseIdentifier {
    return @"TPOSTransactionCellIdentifier";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self.contentView addSubview:self.titleLabel];
//    [self.contentView addSubview:self.valueLabel];
    [self.contentView addSubview:self.inputTextField];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(70);
    }];
    
//    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.titleLabel.mas_right).offset(18);
//        make.centerY.equalTo(self.titleLabel);
//        make.right.equalTo(self.contentView).offset(60);
//    }];
    
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(18);
        make.height.mas_equalTo(60);
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.contentView).offset(-15);
    }];
}

- (void)textFieldEnable:(BOOL)enable {
    self.inputTextField.userInteractionEnabled = enable;
//    if (enable) {
//        self.inputTextField.text = self.valueLabel.text;
//    } else {
//        self.valueLabel.text = self.inputTextField.text;
//    }
}

- (void)updateWithTitle:(NSString *)title value:(NSString *)value {
    self.titleLabel.text = title;
    self.inputTextField.text = value;
//    if (self.inputTextField.userInteractionEnabled) {
//        self.inputTextField.text = value;
//    } else {
//        self.valueLabel.text = value;
//    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([_delegate respondsToSelector:@selector(transactionCell:valueChange:)]) {
        [_delegate transactionCell:self valueChange:textField.text];
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor colorWithHex:0x333333];
        _titleLabel = label;
    }
    return _titleLabel;
}

//- (UILabel *)valueLabel {
//    if (!_valueLabel) {
//        UILabel *label = [UILabel new];
//        label.font = [UIFont systemFontOfSize:16];
//        label.textColor = [UIColor colorWithHex:0x333333];
//        label.lineBreakMode = NSLineBreakByTruncatingMiddle;
//        _valueLabel = label;
//    }
//    return _valueLabel;
//}

- (UITextField *)inputTextField {
    if (!_inputTextField) {
        UITextField *textField = [[UITextField alloc] init];
        textField.font = [UIFont systemFontOfSize:16];
        textField.textColor = [UIColor colorWithHex:0x333333];
        textField.userInteractionEnabled = NO;
        textField.delegate = self;
        _inputTextField = textField;
    }
    return _inputTextField;
}

@end
