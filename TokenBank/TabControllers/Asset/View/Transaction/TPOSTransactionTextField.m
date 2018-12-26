//
//  TPOSTransactionTextField.m
//  TokenBank
//
//  Created by MarcusWoo on 09/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import "TPOSTransactionTextField.h"
#import <Masonry/Masonry.h>

@interface TPOSTransactionTextField()
@property (weak, nonatomic) IBOutlet UIView *line;
@end

@implementation TPOSTransactionTextField

+ (TPOSTransactionTextField *)transactionTextfieldWithType:(TPOSTransactionTextFieldType)type {
    
    TPOSTransactionTextField *textfield = (TPOSTransactionTextField *)[[NSBundle mainBundle] loadNibNamed:@"TPOSTransactionTextField" owner:nil options:nil].firstObject;
    [textfield setViewType:type];
    return textfield;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.bottom.equalTo(self);
        make.height.equalTo(@1);
    }];
    
    [self.textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.bottom.equalTo(self.mas_bottom).offset(-13);
        make.height.equalTo(@20);
        make.right.equalTo(self.mas_right).offset(-20);
    }];
    
    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.centerY.equalTo(self.textfield.mas_centerY);
        make.width.equalTo(@42);
        make.height.equalTo(@20);
    }];
    
    [self.contactButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.centerY.equalTo(self.textfield.mas_centerY);
        make.width.height.equalTo(@22);
    }];
}

- (void)setViewType:(TPOSTransactionTextFieldType)type {
    CGFloat masRight = -20;
    if (type == TPOSTransactionTextFieldTypeNoraml) {
        self.unitLabel.hidden = YES;
        self.contactButton.hidden = YES;
        masRight = -20;
    } else if (type == TPOSTransactionTextFieldTypeContact) {
        self.unitLabel.hidden = YES;
        self.contactButton.hidden = NO;
        masRight = -50;
    } else if (type == TPOSTransactionTextFieldTypeUnit) {
        self.unitLabel.hidden = NO;
        self.contactButton.hidden = YES;
        masRight = -70;
    }
    [self.textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.bottom.equalTo(self.mas_bottom).offset(-13);
        make.height.equalTo(@20);
        make.right.equalTo(self.mas_right).offset(masRight);
    }];
}

@end
