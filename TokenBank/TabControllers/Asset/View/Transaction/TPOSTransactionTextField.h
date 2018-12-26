//
//  TPOSTransactionTextField.h
//  TokenBank
//
//  Created by MarcusWoo on 09/01/2018.
//  Copyright © 2018 MarcusWoo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TPOSTransactionTextFieldType) {
    TPOSTransactionTextFieldTypeNoraml = 0,
    TPOSTransactionTextFieldTypeContact = 1,
    TPOSTransactionTextFieldTypeUnit = 2
};

@interface TPOSTransactionTextField : UIView
@property (weak, nonatomic) IBOutlet UITextField *textfield;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UIButton *contactButton;
+ (TPOSTransactionTextField *)transactionTextfieldWithType:(TPOSTransactionTextFieldType)type;
- (void)setViewType:(TPOSTransactionTextFieldType)type;
@end
